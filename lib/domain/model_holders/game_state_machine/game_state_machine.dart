import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../di/repositories.dart';
import '../../../services/game_logic_service.dart';
import '../../../utils/logs.dart';
import '../../models/game/blind_level_model.dart';
import '../../models/game/blind_progression_model.dart';
import '../../models/game/game_progression_state.dart';
import '../../models/game/game_session_state.dart';
import '../../models/game/game_state_effect.dart';
import '../../models/game/game_state_enum.dart';
import '../../models/game/game_state_model.dart';
import '../../models/lobby/lobby_state_model.dart';
import '../../models/player/player_id.dart';
import '../../models/player/player_model.dart';
import '../lobby_state_holder.dart';
import 'previous_state_notifier.dart';

/// Main class with game logic
class GameStateMachine extends AsyncNotifier<GameStateModel> {
  LobbyStateHolder get _lobbyStateHolder =>
      ref.read(lobbyStateHolderProvider.notifier);

  GamePreviousStateNotifier get _previousStateNotifier =>
      ref.read(gamePreviousStateNotifierProvider.notifier);
  StatePair get _previousState => ref.read(gamePreviousStateNotifierProvider);

  bool get canUndoAction => _previousState.previous != null;

  @override
  FutureOr<GameStateModel> build() async {
    logs.writeLog('GameSM: BUILDING Initial STATE');

    // Reading because can't change lobbyStateHolder from this page
    final lobbyState = await ref.read(lobbyStateHolderProvider.future);
    final gameState =
        await ref.read(appRepositoryProvider).getGameSessionState();

    final sessionState = lobbyState.gameState.isStarted
        ? state.value?.sessionState ?? gameState
        : null;

    final normalizedSessionState = _normalizeSessionState(
      lobbyState: lobbyState,
      sessionState: sessionState ?? GameSessionState.initial(),
      nowUtc: _nowUtc(),
    );

    final result = _autoFoldInactivePlayers(
      GameStateModel(
        lobbyState: lobbyState,
        sessionState: normalizedSessionState,
      ),
    );

    if (result.lobbyState.gameState == GameStatusEnum.showdown) {
      return _resetShowdownEffects(result);
    }

    return result;
  }

  Future<void> undoLastAction() async {
    final pair = _previousState;
    logs.writeLog('GameSM: undo action');

    // Can sometimes loose previous step because of game restoring
    final previous =
        pair.previous == state.value ? pair.current : pair.previous;

    if (previous != null) {
      // Clearing effects that don't have to be shown on undo
      await _updateGame(
        previous.copyWith(
          effects: previous.effects
              .whereType<GameStateNeedWinnerSelectionEffect>()
              .toList(),
        ),
        clearPreviousState: true,
      );
    }
  }

  /// The first method in game, is contolling by client (current player)
  /// Places the initial bets and determines the first player to bet
  Future<void> startBetting() async {
    final currentModel = _removeEffects(state.requireValue);

    if (!currentModel.canStartOrContinueGame) {
      logs.writeLog('GameSM: cannot start betting');

      return _returnErrorEffect(GameStateErrorType.fewPlayers);
    }

    logs.writeLog('GameSM: starting betting');

    // 1. Create the initial state for the new hand
    final preparedSessionState = _prepareSessionForHandStart(
      currentModel.sessionState,
      progression: currentModel.lobbyState.settings.progression,
      nowUtc: _nowUtc(),
    );

    final initialHandState = currentModel.copyWith(
      lobbyState: currentModel.lobbyState.copyWith(
        gameState: GameStatusEnum.preFlop,
      ),
      sessionState: preparedSessionState.copyWith(lapCounter: 0),
    );

    // 2. Calculate the state after posting blinds
    final stateAfterBlinds = _processFirstBlinds(initialHandState);

    // 3. Update the game state
    await _updateGame(stateAfterBlinds);
  }

  ///  Raise execution, is calling by client (current player)
  Future<void> executeRaise(int raiseValue) => _executeBet(raiseValue);

  ///  AllIn execution, is calling by client (current player)
  Future<void> executeAllIn() {
    final currentModel = state.requireValue;
    final currentPlayerUid = _getCurrentPlayerUid(currentModel);

    final bank = currentModel.lobbyState.banks[currentPlayerUid] ?? 0;

    logs.writeLog('GameSM: executeAllIn $bank');
    return _executeBet(bank);
  }

  ///  Call execution, is calling by client (current player)
  Future<void> executeCall() {
    final model = state.requireValue;
    final currentPlayerUid = model.sessionState.currentPlayerUid;

    if (currentPlayerUid == null) {
      throw Exception('currentPlayerUid is null');
    }

    final (callValue, _) =
        state.requireValue.calculateCallValue(currentPlayerUid);

    return _executeBet(callValue);
  }

  ///  Check execution, is calling by client (current player)
  Future<void> executeCheck() async {
    logs.writeLog('GameSM: executeCheck');

    final nextState = _calculateNextPlayerState(state.requireValue);
    await _updateGame(nextState);
  }

  ///  Fold execution, is calling by client (current player)
  Future<void> executeFold() async {
    final currentModel = state.requireValue;
    final sessionState = currentModel.sessionState;

    final currentPlayerUid = _getCurrentPlayerUid(currentModel);

    // 1. Update Folded map
    final newFolded = Set.of(sessionState.foldedPlayers)..add(currentPlayerUid);
    final tempSession = sessionState.copyWith(foldedPlayers: newFolded);
    final tempGameModel = currentModel.copyWith(sessionState: tempSession);

    // 3. Calculate final state
    final nextState = _calculateNextPlayerState(tempGameModel);
    await _updateGame(nextState);
  }

  /// Winner selection execution, is calling by client
  Future<void> executeWinnerSelection({
    required Set<String> selectedWinners,
  }) async {
    final model1 = state.requireValue;

    final model2 = await _moneyDistribution(
      model: model1,
      winners: selectedWinners,
    );

    //If have side spot event - not saving game
    if (model2.effects.isNotEmpty) {
      state = AsyncData(model2);

      return;
    }

    final model3 = _toBreakdown(model: model2);

    await _updateGame(
      model3,
      savePreviousState: false,
    );
  }

  Future<void> nextLevel() async {
    final currentModel = state.requireValue;
    final currentLevelIndex =
        currentModel.sessionState.progressionState.currentLevelIndex;

    return _setManualProgressionLevel(currentLevelIndex + 1);
  }

  /// Updates the active manual level during breakdown and persists it
  /// together with the normalized progression session state.
  Future<void> _setManualProgressionLevel(int levelIndex) async {
    final currentModel = state.requireValue;
    final progression = currentModel.lobbyState.settings.progression;

    if (!currentModel.lobbyState.gameState.canEditPlayers ||
        progression.progressionType != BlindProgressionType.manual) {
      return;
    }

    final safeIndex = levelIndex.clamp(0, progression.levels.length - 1);
    final updatedProgressionState = _normalizeProgressionState(
      progressionState: currentModel.sessionState.progressionState.copyWith(
        currentLevelIndex: safeIndex,
      ),
      progression: progression,
      nowUtc: _nowUtc(),
      initializeMissingSchedule: true,
    );

    await _updateGame(
      currentModel.copyWith(
        sessionState: currentModel.sessionState.copyWith(
          progressionState: updatedProgressionState,
        ),
        effects: [],
      ),
    );
  }

  GameStateModel _resetShowdownEffects(GameStateModel model) => model.copyWith(
        effects: [
          if (model.effects.isEmpty && model.activePlayers.length > 1)
            _buildWinnerSelectionEffect(
              model: model,
              isSideSpot: false,
            ),
        ],
      );

  GameStateModel _removeEffects(GameStateModel model) =>
      model.copyWith(effects: []);

  GameStateEffect _buildWinnerSelectionEffect({
    required GameStateModel model,
    required bool isSideSpot,
  }) {
    final layer = _buildDistributionLayer(
      model: model,
      sessionState: model.sessionState,
    );

    if (layer == null) {
      return GameStateEffect.needWinnerSelection(isSideSpot: isSideSpot);
    }

    return GameStateEffect.needWinnerSelection(
      isSideSpot: isSideSpot,
      potValue: layer.potValue,
      anteValue: layer.anteValue,
      foldedValue: layer.foldedValue,
      playerContributions: layer.possibleWinnerContributions,
    );
  }

  // Notifing the client of winner or requirement of winners selection
  GameStateModel _selectWinnersOnShowdown({
    required GameStateModel model,
  }) {
    GameStateModel model2;

    // 1.1 If win from folds, show 1 winner
    final winFromFold = model.activePlayers.length == 1;

    if (winFromFold) {
      final winner = model.activePlayers.first;
      final totalBets = model.sessionState.bets.values.sum +
          model.sessionState.anteBets.values.sum;
      final newBanks = Map.of(model.lobbyState.banks)
        ..update(winner.uid, (value) => value + totalBets);

      model2 = model.copyWith(
        lobbyState: model.lobbyState.copyWith(
          gameState: GameStatusEnum.showdown,
          banks: newBanks,
        ),
        effects: [
          GameStateEffect.hasWinner(winnerUid: winner.uid),
        ],
      );

      // Updating state to breakdown and return winner
      return _toBreakdown(model: model2);
    } else {
      // 2.2. Else need to select winner
      logs.writeLog('Call WinnerChooseWindow');

      // Returning possible winners uids to client
      model2 = model.copyWith(
        lobbyState: model.lobbyState.copyWith(
          gameState: GameStatusEnum.showdown,
        ),
        effects: [
          _buildWinnerSelectionEffect(
            model: model,
            isSideSpot: false,
          ),
        ],
      );

      return model2;
    }
  }

  // Calculate current player uid
  String _getCurrentPlayerUid(GameStateModel model) {
    final currentPlayerUid = model.sessionState.currentPlayerUid;

    if (currentPlayerUid == null) {
      throw Exception('Run _getCurrentPlayerUid with no player');
    }

    return currentPlayerUid;
  }

  // Update player bank and bet
  GameStateModel _processBet({
    required GameStateModel model,
    required PlayerId playerId,
    required int bid,
  }) {
    final newBets = Map.of(model.sessionState.bets)
      ..update(
        playerId,
        (value) => value + bid,
        ifAbsent: () => bid,
      );

    final newBanks = Map.of(model.lobbyState.banks)
      ..update(
        playerId,
        (value) => value - bid,
        ifAbsent: () => 0,
      );

    return model.copyWith(
      lobbyState: model.lobbyState.copyWith(banks: newBanks),
      sessionState: model.sessionState.copyWith(bets: newBets),
    );
  }

  GameStateModel _processAnte({
    required GameStateModel model,
    required PlayerId playerId,
    required int ante,
  }) {
    final newAnteBets = Map<String, int>.from(model.sessionState.anteBets)
      ..update(
        playerId,
        (value) => value + ante,
        ifAbsent: () => ante,
      );

    final newBanks = Map.of(model.lobbyState.banks)
      ..update(
        playerId,
        (value) => value - ante,
        ifAbsent: () => 0,
      );

    return model.copyWith(
      lobbyState: model.lobbyState.copyWith(banks: newBanks),
      sessionState: model.sessionState.copyWith(anteBets: newAnteBets),
    );
  }

  // Update current players bank/bet and find next player
  Future<void> _executeBet(int bid) async {
    logs.writeLog('GameSM: executeBet $bid');
    final currentModel = state.requireValue;
    final currentPlayerUid = _getCurrentPlayerUid(currentModel);

    // 1. Update bet and banks map
    final newSession = _processBet(
      model: currentModel,
      playerId: currentPlayerUid,
      bid: bid,
    );

    // 2. Calculate the next player and game phase
    final finalState = _calculateNextPlayerState(newSession);

    // 3. Update the game state
    await _updateGame(finalState);
  }

  // Method calls by server after winner selection, change players banks according of their bets
  Future<GameStateModel> _moneyDistribution({
    required GameStateModel model,
    required Set<String> winners,
  }) async {
    logs.writeLog('GameSM: distrubuteMoney $winners');

    var lobbyState = model.lobbyState;
    var sessionState = model.sessionState;

    while (true) {
      final layer = _buildDistributionLayer(
        model: model,
        sessionState: sessionState,
      );

      if (layer == null) {
        return GameStateModel(
          lobbyState: lobbyState,
          sessionState: sessionState,
          effects: [],
        );
      }

      if (winners.isEmpty) {
        // If we erase winners on previous pot and still have contributions - it means we have side spot

        // If we have more than 1 player in side spot - we need to select winner in UI
        if (layer.possibleWinnerContributions.length > 1) {
          logs.writeLog('GameSM: need to call winnerChooseDialog');

          return model.copyWith(
            sessionState: sessionState,
            effects: [
              GameStateEffect.needWinnerSelection(
                isSideSpot: true,
                potValue: layer.potValue,
                anteValue: layer.anteValue,
                foldedValue: layer.foldedValue,
                playerContributions: layer.possibleWinnerContributions,
              ),
            ],
          );
        }

        // If we have only 1 player in side spot - he overpaid for some reason, just return money
        final winnerUid = layer.possibleWinnerContributions.keys.singleOrNull;
        if (winnerUid == null) {
          return GameStateModel(
            lobbyState: lobbyState,
            sessionState: sessionState,
            effects: [],
          );
        }

        final newBanks = Map.of(lobbyState.banks)
          ..update(
            winnerUid,
            (value) => value + layer.potValue,
          );

        lobbyState = lobbyState.copyWith(banks: newBanks);
      } else {
        // Happy pass - if all winners are in current layer, just distribute money and finish
        final eligibleWinners = winners
            .where(layer.possibleWinnerContributions.containsKey)
            .toSet();

        if (eligibleWinners.isEmpty) {
          return GameStateModel(
            lobbyState: lobbyState,
            sessionState: sessionState,
            effects: [],
          );
        }

        final sumPerPerson = layer.potValue ~/ eligibleWinners.length;

        for (final winnerUid in eligibleWinners) {
          logs.writeLog('GameSM: adding $sumPerPerson to $winnerUid');
          final newBanks = Map.of(lobbyState.banks)
            ..update(
              winnerUid,
              (value) => value + sumPerPerson,
            );
          lobbyState = lobbyState.copyWith(banks: newBanks);
        }

        winners = <String>{};
      }

      sessionState = _consumeDistributionLayer(
        model: model,
        sessionState: sessionState,
        layer: layer,
      );

      model = GameStateModel(
        sessionState: sessionState,
        lobbyState: lobbyState,
        effects: [],
      );
    }
  }

  _DistributionLayer? _buildDistributionLayer({
    required GameStateModel model,
    required GameSessionState sessionState,
  }) {
    Map<String, int> buildDistributionBets({
      required GameStateModel model,
      required GameSessionState sessionState,
    }) {
      if (model.currentAnteType != AnteType.traditional) {
        return sessionState.bets;
      }

      final mergedBets = <String, int>{};
      final playerUids = {
        ...sessionState.bets.keys,
        ...sessionState.anteBets.keys,
      };

      for (final playerUid in playerUids) {
        final total = (sessionState.bets[playerUid] ?? 0) +
            (sessionState.anteBets[playerUid] ?? 0);
        if (total > 0) {
          mergedBets[playerUid] = total;
        }
      }

      return mergedBets;
    }

    final effectiveBets = buildDistributionBets(
      model: model,
      sessionState: sessionState,
    );

    final activeContributors = model.activePlayers
        .where((player) => (effectiveBets[player.uid] ?? 0) > 0)
        .toList();

    if (activeContributors.isEmpty) {
      return null;
    }

    final totalBid =
        activeContributors.map((player) => effectiveBets[player.uid] ?? 0).min;
    final participantContributions = <String, int>{};
    var foldedValue = 0;

    var maxConsumedBet = 0;
    var totalConsumedAnte = 0;

    for (final player in model.lobbyState.players) {
      final contribution = min(effectiveBets[player.uid] ?? 0, totalBid);
      if (contribution <= 0) {
        continue;
      }

      participantContributions[player.uid] = contribution;

      var consumedAnte = 0;
      var consumedBet = 0;
      if (model.currentAnteType == AnteType.traditional) {
        consumedAnte =
            min(sessionState.anteBets[player.uid] ?? 0, contribution);
        consumedBet = contribution - consumedAnte;
      } else {
        consumedBet = contribution;
      }

      totalConsumedAnte += consumedAnte;
      maxConsumedBet = max(maxConsumedBet, consumedBet);

      // If player is folded - his bet goes to deadmoney
      if (!model.isPlayerActive(player.uid)) {
        foldedValue += contribution;
      }
    }

    final anteValue = model.currentAnteType == AnteType.bigBlindAnte
        ? sessionState.anteBets.values.sum
        : totalConsumedAnte;

    final basePotValue = participantContributions.values.sum;
    final potValue = model.currentAnteType == AnteType.bigBlindAnte
        ? basePotValue + anteValue
        : basePotValue;

    return _DistributionLayer(
      potValue: potValue,
      anteValue: anteValue,
      foldedValue: foldedValue,
      possibleWinnerContributions: {
        for (final player in activeContributors) player.uid: totalBid,
      },
      participantContributions: participantContributions,
    );
  }

  /// Reducing player bets on current layer and ante bets
  GameSessionState _consumeDistributionLayer({
    required GameStateModel model,
    required GameSessionState sessionState,
    required _DistributionLayer layer,
  }) {
    final newBets = Map<String, int>.from(sessionState.bets);
    final newAnteBets = Map<String, int>.from(sessionState.anteBets);

    for (final entry in layer.participantContributions.entries) {
      final playerUid = entry.key;
      var remainingContribution = entry.value;

      if (model.currentAnteType == AnteType.traditional) {
        final anteValue = newAnteBets[playerUid] ?? 0;
        final consumedAnte = min(anteValue, remainingContribution);
        final anteLeft = anteValue - consumedAnte;

        if (anteLeft > 0) {
          newAnteBets[playerUid] = anteLeft;
        } else {
          newAnteBets.remove(playerUid);
        }

        remainingContribution -= consumedAnte;
      }

      final betValue = newBets[playerUid] ?? 0;
      final betLeft = betValue - remainingContribution;
      if (betLeft > 0) {
        newBets[playerUid] = betLeft;
      } else {
        newBets.remove(playerUid);
      }
    }

    if (model.currentAnteType == AnteType.bigBlindAnte && layer.anteValue > 0) {
      newAnteBets.clear();
    }

    return sessionState.copyWith(
      bets: newBets,
      anteBets: newAnteBets,
    );
  }

  // Next player determination
  GameStateModel _calculateNextPlayerState(GameStateModel model) {
    final currentModel = _removeEffects(model);

    logs.writeLog('GameSM: finding next player state');
    var currentSession = currentModel.sessionState;
    final currentLobby = currentModel.lobbyState;

    final bidsEqual = currentModel.checkBidsEqual();
    logs.writeLog('GameSM: bidsEqual $bidsEqual');

    // 1. FORCE SHOWDOWN IF BETS EQUAL AND ONLY ONE LAST WITH MONEY
    if (bidsEqual && currentModel.activePlayersWithMoneyCount <= 1) {
      logs.writeLog('GameSM: [CNPS] force to showdown');
      return _selectWinnersOnShowdown(model: currentModel);
    }

    // 2. Calculate New Player
    final (nextPlayerUid, shouldIncrementLap) = _nextPlayerUid(
      model: currentModel,
      fromUid: _getCurrentPlayerUid(currentModel),
    );

    // 3. Update lapCount if needed
    if (shouldIncrementLap) {
      logs.writeLog('GameSM: [CNPS] increment lapCounter');
      currentSession = currentSession.copyWith(
        lapCounter: currentSession.lapCounter + 1,
      );
    }

    // 4. If one lap ended and bets are equal -> can jump to new street
    if (bidsEqual && currentSession.lapCounter > 0) {
      logs.writeLog('GameSM: [CNPS] need new street');
      return _calculateNewStreet(
        GameStateModel(
          lobbyState: currentLobby,
          sessionState: currentSession,
        ),
      );
    }

    // 5. Update current player and return
    currentSession = currentSession.copyWith(
      currentPlayerUid: nextPlayerUid,
    );

    return currentModel.copyWith(sessionState: currentSession);
  }

  // Finding next player uid, skip folded players and with allin case
  // Increasing lap counter if needed
  (PlayerId?, bool) _nextPlayerUid({
    required GameStateModel model,
    required PlayerId fromUid,
  }) {
    final players = model.lobbyState.players;
    final fromIndex = players.indexWhere((p) => p.uid == fromUid);

    var shouldIncrementLap = false;

    for (int i = 1; i <= players.length; i++) {
      final nextIndex = (fromIndex + i) % players.length;
      final nextPlayer = players[nextIndex];

      shouldIncrementLap = shouldIncrementLap ||
          (nextPlayer.uid == model.sessionState.firstPlayerUid);

      if (model.isPlayerActiveWithMoney(nextPlayer.uid)) {
        logs.writeLog('GameSM: next player should be ${nextPlayer.name}');
        return (nextPlayer.uid, shouldIncrementLap);
      }
    }

    return (null, false);
  }

  // New street calculation
  GameStateModel _calculateNewStreet(GameStateModel currentModel) {
    final nextStreet = currentModel.lobbyState.gameState.next;

    logs.writeLog('GameSM: setup new street ${nextStreet.name}');

    final newLobbyState = currentModel.lobbyState.copyWith(
      gameState: currentModel.lobbyState.gameState.next,
    );

    // 1. RETURN CURRENT STATE IN SHOWDOWN
    if (nextStreet == GameStatusEnum.showdown) {
      logs.writeLog('GameSM: new street is showdown, returning to UI');
      return _selectWinnersOnShowdown(model: currentModel);
    }

    // 2. Reset lap counter for new street
    var newSessionState = currentModel.sessionState.copyWith(
      lapCounter: 0,
    );

    // 3. Reset firstPlayer
    final dealerPosition = newLobbyState.players
        .indexWhere((p) => p.uid == newLobbyState.dealerId);

    for (int i = 1; i < newLobbyState.players.length; i++) {
      int localIndex = (i + dealerPosition) % newLobbyState.players.length;
      final localPlayer = newLobbyState.players[localIndex];

      if (currentModel.isPlayerActiveWithMoney(localPlayer.uid)) {
        logs.writeLog(
          'GameSM: first player in new street is ${localPlayer.name}',
        );
        newSessionState = newSessionState.copyWith(
          currentPlayerUid: localPlayer.uid,
          firstPlayerUid: localPlayer.uid,
        );
        break;
      }
    }

    return GameStateModel(
      lobbyState: newLobbyState,
      sessionState: newSessionState,
    );
  }

  GameStateModel _toBreakdown({required GameStateModel model}) {
    logs.writeLog('GameSM: prepare state for breakdown');

    final nowUtc = _nowUtc();
    final progressionState = _advanceProgressionOnBreakdown(
      sessionState: model.sessionState,
      progression: model.lobbyState.settings.progression,
      nowUtc: nowUtc,
    );

    final model1 = model.copyWith(
      sessionState: model.sessionState.copyWith(
        bets: {},
        anteBets: {},
        foldedPlayers: {},
        firstPlayerUid: null,
        currentPlayerUid: null,
        lapCounter: 0,
        progressionState: progressionState,
      ),
    );

    final model2 = model1.copyWith(
      lobbyState: model1.lobbyState.copyWith(
        dealerId: _getNewDealerUid(model: model1),
        gameState: GameStatusEnum.gameBreak,
      ),
    );

    return _autoFoldInactivePlayers(model2);
  }

  String? _getNewDealerUid({required GameStateModel model}) {
    final lobby = model.lobbyState;
    final dealerPosition =
        lobby.players.indexWhere((p) => p.uid == lobby.dealerId);

    // finding dealer
    for (int i = 1; i < lobby.players.length; i++) {
      int localIndex = (i + dealerPosition) % lobby.players.length;
      final localPlayer = lobby.players[localIndex];

      if (model.isPlayerActiveWithMoney(localPlayer.uid)) {
        logs.writeLog('GameSM: new dealer is ${localPlayer.name}');
        return localPlayer.uid;
      }
    }
    logs.writeLog('GameSM: new dealer not found, returning ${lobby.dealerId}');
    return lobby.dealerId;
  }

  // Performing the first blinds
  GameStateModel _processFirstBlinds(GameStateModel model) {
    logs.writeLog('GameSM: processing first blinds');

    var editableModel = model;
    LobbyStateModel currentLobby() => editableModel.lobbyState;
    GameSessionState currentSession() => editableModel.sessionState;

    int findNextActivePosition({
      required GameStateModel model,
      required int fromPosition,
      int initialOffset = 1,
    }) {
      final players = model.lobbyState.players;

      for (int i = initialOffset; i <= players.length; i++) {
        final localIndex = (fromPosition + i) % players.length;
        final player = players[localIndex];

        if (model.isPlayerActive(player.uid)) {
          return localIndex;
        }
      }

      return fromPosition;
    }

    GameStateModel processBetOrAllIn({
      required GameStateModel modelToProcess,
      required PlayerModel player,
      required int value,
    }) {
      final bank = modelToProcess.lobbyState.banks[player.uid] ?? 0;
      final actualBid = min(bank, value);

      if (actualBid <= 0) {
        return modelToProcess;
      }

      return _processBet(
        model: modelToProcess,
        playerId: player.uid,
        bid: actualBid,
      );
    }

    GameStateModel processAnteOrAllIn({
      required GameStateModel modelToProcess,
      required PlayerModel player,
      required int value,
    }) {
      final bank = modelToProcess.lobbyState.banks[player.uid] ?? 0;
      final actualAnte = min(bank, value);

      if (actualAnte <= 0) {
        return modelToProcess;
      }

      return _processAnte(
        model: modelToProcess,
        playerId: player.uid,
        ante: actualAnte,
      );
    }

    GameStateModel processAntes({
      required GameStateModel model,
      required int dealerPosition,
      required int bigBlindPosition,
    }) {
      final anteType = model.currentAnteType;
      final anteValue = model.currentAnteValue;

      var updatedModel = model;

      if (anteType == AnteType.none || anteValue == null || anteValue <= 0) {
        return updatedModel;
      } else if (anteType == AnteType.bigBlindAnte) {
        final bigBlindPlayer =
            updatedModel.lobbyState.players[bigBlindPosition];

        return processAnteOrAllIn(
          modelToProcess: updatedModel,
          player: bigBlindPlayer,
          value: anteValue,
        );
      } else {
        // AnteType.traditional
        for (int i = 1; i <= updatedModel.lobbyState.players.length; i++) {
          final localIndex =
              (dealerPosition + i) % updatedModel.lobbyState.players.length;
          final player = updatedModel.lobbyState.players[localIndex];

          if (!updatedModel.isPlayerActive(player.uid)) {
            continue;
          }

          updatedModel = processAnteOrAllIn(
            modelToProcess: updatedModel,
            player: player,
            value: anteValue,
          );
        }
      }

      return updatedModel;
    }

    final dealerPosition = currentLobby()
        .players
        .indexWhere((p) => p.uid == currentLobby().dealerId);

    // HEAD UP case
    final isHandsUp = editableModel.activePlayersWithMoney.length == 2;
    final smallBlindPosition = findNextActivePosition(
      model: editableModel,
      fromPosition: dealerPosition,
      initialOffset: isHandsUp ? 0 : 1,
    );
    final bigBlindPosition = findNextActivePosition(
      model: editableModel,
      fromPosition: smallBlindPosition,
    );

    // Small blind bet
    if (editableModel.currentAnteType == AnteType.traditional) {
      editableModel = processAntes(
        model: editableModel,
        dealerPosition: dealerPosition,
        bigBlindPosition: bigBlindPosition,
      );
    }

    editableModel = processBetOrAllIn(
      modelToProcess: editableModel,
      player: currentLobby().players[smallBlindPosition],
      value: editableModel.currentSmallBlindValue,
    );

    // Big blind bet
    editableModel = processBetOrAllIn(
      modelToProcess: editableModel,
      player: currentLobby().players[bigBlindPosition],
      value: editableModel.currentBigBlindValue,
    );

    if (editableModel.currentAnteType == AnteType.bigBlindAnte) {
      editableModel = processAntes(
        model: editableModel,
        dealerPosition: dealerPosition,
        bigBlindPosition: bigBlindPosition,
      );
    }

    if (editableModel.checkBidsEqual() &&
        editableModel.activePlayersWithMoneyCount <= 1) {
      logs.writeLog('GameSM: head-up showdown forcing');
      return _selectWinnersOnShowdown(
        model: GameStateModel(
          lobbyState: currentLobby(),
          sessionState: currentSession(),
        ),
      );
    }

    // Searching for first player
    for (int i = 1; i < currentLobby().players.length; i++) {
      int localIndex = (i + bigBlindPosition) % currentLobby().players.length;

      final localPlayer = currentLobby().players[localIndex];

      if (editableModel.isPlayerActiveWithMoney(localPlayer.uid)) {
        editableModel = editableModel.copyWith(
          sessionState: editableModel.sessionState.copyWith(
            currentPlayerUid: localPlayer.uid,
            firstPlayerUid: localPlayer.uid,
          ),
        );

        logs.writeLog('GameSM: first player would be ${localPlayer.name}');
        break;
      }
    }
    return editableModel;
  }

  // Making players with no money folded
  GameStateModel _autoFoldInactivePlayers(GameStateModel model) {
    final foldedByBank = <GameStatusEnum>{
      GameStatusEnum.notStarted,
      GameStatusEnum.gameBreak
    }.contains(model.lobbyState.gameState)
        ? model.lobbyState.banks.entries
            .map((e) => e.value <= 0 ? e.key : null)
            .nonNulls
            .toSet()
        : <String>{};

    final foldedPlayers = Set<String>.from(model.sessionState.foldedPlayers)
      ..addAll(foldedByBank);

    return model.copyWith(
      sessionState: model.sessionState.copyWith(
        foldedPlayers: foldedPlayers,
      ),
    );
  }

  Future<void> _updateGame(
    GameStateModel newModel, {
    bool savePreviousState = true,
    bool clearPreviousState = false,
  }) async {
    logs.writeLog('GameSM: UPDATE GAME');

    if (savePreviousState) {
      _previousStateNotifier.setState((
        previous: state.value,
        current: newModel,
      ));
    }
    if (clearPreviousState) {
      _previousStateNotifier.clearPrevious();
    }

    state = AsyncData(newModel);

    await _lobbyStateHolder.updateLobby(newModel.lobbyState);

    try {
      await ref
          .read(appRepositoryProvider)
          .updateGameSessionState(newModel.sessionState);
    } catch (e) {
      logs.writeLog('Save game session state error: $e');
    }
  }

  void _returnErrorEffect(GameStateErrorType type) {
    state = AsyncData(
      state.requireValue.copyWith(
        effects: [
          GameStateEffect.error(type: type),
        ],
      ),
    );
  }

  /// Returns a single UTC timestamp source so progression calculations
  /// are consistent across restore, hand start and breakdown transitions.
  DateTime _nowUtc() => ref.read(currentTimeProvider)();

  /// Restores progression-related session fields after app launch.
  /// During breakdown it also applies any overdue timed transitions.
  GameSessionState _normalizeSessionState({
    required LobbyStateModel lobbyState,
    required GameSessionState sessionState,
    required DateTime nowUtc,
  }) {
    final progression = lobbyState.settings.progression;
    final baseState = _normalizeProgressionState(
      progressionState: sessionState.progressionState,
      progression: progression,
      nowUtc: nowUtc,
      initializeMissingSchedule: lobbyState.gameState.isStarted,
    );

    if (lobbyState.gameState != GameStatusEnum.gameBreak) {
      return sessionState.copyWith(progressionState: baseState);
    }

    final advancedState = _advanceTimedLevelsIfNeeded(
      progressionState: baseState,
      progression: progression,
      nowUtc: nowUtc,
    );

    return sessionState.copyWith(progressionState: advancedState);
  }

  /// Prepares progression data right before a new hand starts.
  /// This ensures missing counters or timers are initialized for the
  /// currently selected progression mode.
  GameSessionState _prepareSessionForHandStart(
    GameSessionState sessionState, {
    required BlindProgressionModel progression,
    required DateTime nowUtc,
  }) =>
      sessionState.copyWith(
        progressionState: _normalizeProgressionState(
          progressionState: sessionState.progressionState,
          progression: progression,
          nowUtc: nowUtc,
          initializeMissingSchedule: true,
        ),
      );

  /// Advances progression only when a hand has fully ended and the game
  /// entered breakdown. Hands-based progression is decremented here,
  /// while timed progression is caught up against the current time.
  GameProgressionState _advanceProgressionOnBreakdown({
    required GameSessionState sessionState,
    required BlindProgressionModel progression,
    required DateTime nowUtc,
  }) {
    final normalizedState = _normalizeProgressionState(
      progressionState: sessionState.progressionState,
      progression: progression,
      nowUtc: nowUtc,
      initializeMissingSchedule: true,
    );

    final timedState = _advanceTimedLevelsIfNeeded(
      progressionState: normalizedState,
      progression: progression,
      nowUtc: nowUtc,
    );

    if (progression.progressionType != BlindProgressionType.everyNHands) {
      return timedState;
    }

    final interval = progression.progressionInterval;
    if (interval == null || interval <= 0) {
      return timedState.copyWith(handsUntilNextLevel: null);
    }

    final lastIndex = progression.levels.length - 1;
    if (timedState.currentLevelIndex >= lastIndex) {
      return timedState.copyWith(handsUntilNextLevel: null);
    }

    final handsLeft = (timedState.handsUntilNextLevel ?? interval) - 1;
    if (handsLeft > 0) {
      return timedState.copyWith(handsUntilNextLevel: handsLeft);
    }

    final newLevelIndex = min(timedState.currentLevelIndex + 1, lastIndex);
    final handsUntilNextLevel = newLevelIndex >= lastIndex ? null : interval;

    return timedState.copyWith(
      currentLevelIndex: newLevelIndex,
      handsUntilNextLevel: handsUntilNextLevel,
    );
  }

  /// Normalizes progression fields for the active progression mode
  GameProgressionState _normalizeProgressionState({
    required GameProgressionState progressionState,
    required BlindProgressionModel progression,
    required DateTime nowUtc,
    required bool initializeMissingSchedule,
  }) {
    final levels = progression.levels;
    final safeIndex = progressionState.currentLevelIndex.clamp(
      0,
      max(0, levels.length - 1),
    ) as int;

    switch (progression.progressionType) {
      // For manual progression we just need to ensure the level index is within bounds and clear timers.
      case BlindProgressionType.manual:
        return progressionState.copyWith(
          currentLevelIndex: safeIndex,
          handsUntilNextLevel: null,
          nextLevelAtEpochMsUtc: null,
        );
      // For hands-based progression we also clamp the level index, clear timers and ensure the hand counter is initialized.
      case BlindProgressionType.everyNHands:
        final interval = progression.progressionInterval;
        final isLastLevel = safeIndex >= levels.length - 1;
        final handsUntilNextLevel = interval == null || interval <= 0
            ? null
            : isLastLevel
                ? null
                : progressionState.handsUntilNextLevel ?? interval;

        return progressionState.copyWith(
          currentLevelIndex: safeIndex,
          handsUntilNextLevel: handsUntilNextLevel,
          nextLevelAtEpochMsUtc: null,
        );
      // For timed progression we clamp the level index, clear hand counters and ensure the next-level timestamp is initialized if missing.
      case BlindProgressionType.everyNMinutes:
        final interval = progression.progressionInterval;
        final nextLevelAtEpochMsUtc = interval == null ||
                interval <= 0 ||
                (!initializeMissingSchedule &&
                    progressionState.nextLevelAtEpochMsUtc == null)
            ? progressionState.nextLevelAtEpochMsUtc
            : progressionState.nextLevelAtEpochMsUtc ??
                nowUtc.add(Duration(minutes: interval)).millisecondsSinceEpoch;

        return progressionState.copyWith(
          currentLevelIndex: safeIndex,
          handsUntilNextLevel: null,
          nextLevelAtEpochMsUtc: nextLevelAtEpochMsUtc,
        );
    }
  }

  /// Applies all overdue timed level transitions based on the saved
  /// next-deadline timestamp. This lets the app recover correct blind
  /// state after pause or restart without losing elapsed time.
  GameProgressionState _advanceTimedLevelsIfNeeded({
    required GameProgressionState progressionState,
    required BlindProgressionModel progression,
    required DateTime nowUtc,
  }) {
    if (progression.progressionType != BlindProgressionType.everyNMinutes) {
      return progressionState;
    }

    final interval = progression.progressionInterval;
    final nextLevelAtEpochMsUtc = progressionState.nextLevelAtEpochMsUtc;
    if (interval == null || interval <= 0 || nextLevelAtEpochMsUtc == null) {
      return progressionState.copyWith(nextLevelAtEpochMsUtc: null);
    }

    final lastIndex = progression.levels.length - 1;
    if (progressionState.currentLevelIndex >= lastIndex) {
      return progressionState.copyWith(nextLevelAtEpochMsUtc: null);
    }

    final nextLevelAtUtc = DateTime.fromMillisecondsSinceEpoch(
      nextLevelAtEpochMsUtc,
      isUtc: true,
    );
    if (nowUtc.isBefore(nextLevelAtUtc)) {
      return progressionState;
    }

    final intervalDuration = Duration(minutes: interval);
    final elapsed = nowUtc.difference(nextLevelAtUtc);
    final transitions =
        1 + (elapsed.inMilliseconds ~/ intervalDuration.inMilliseconds);
    final newLevelIndex = min(
      progressionState.currentLevelIndex + transitions,
      lastIndex,
    );

    if (newLevelIndex == lastIndex) {
      return progressionState.copyWith(
        currentLevelIndex: newLevelIndex,
        nextLevelAtEpochMsUtc: null,
      );
    }

    final newNextLevelAtUtc = nextLevelAtUtc.add(
      Duration(minutes: interval * transitions),
    );

    return progressionState.copyWith(
      currentLevelIndex: newLevelIndex,
      nextLevelAtEpochMsUtc: newNextLevelAtUtc.millisecondsSinceEpoch,
    );
  }
}

class _DistributionLayer {
  const _DistributionLayer({
    required this.potValue,
    required this.anteValue,
    required this.foldedValue,
    required this.possibleWinnerContributions,
    required this.participantContributions,
  });

  final int potValue;
  final int anteValue;
  final int foldedValue;
  final Map<String, int> possibleWinnerContributions;
  final Map<String, int> participantContributions;
}
