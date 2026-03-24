import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/model_holders.dart';
import '../../../di/repositories.dart';
import '../../../services/game_logic_service.dart';
import '../../../utils/logs.dart';
import '../../models/game/blind_level_model.dart';
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

    final sessionState = lobbyState.gameState.isStarted
        ? state.value?.sessionState ??
            await ref.read(appRepositoryProvider).getGameSessionState()
        : null;

    final result = _autoFoldInactivePlayers(
      GameStateModel(
        lobbyState: lobbyState,
        sessionState: sessionState ?? GameSessionState.initial(),
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
      await _updateGame(
        previous,
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
    final initialHandState = currentModel.copyWith(
      lobbyState: currentModel.lobbyState.copyWith(
        gameState: GameStatusEnum.preFlop,
      ),
      sessionState: currentModel.sessionState.copyWith(lapCounter: 0),
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

  GameStateModel _resetShowdownEffects(GameStateModel model) => model.copyWith(
        effects: [
          if (model.effects.isEmpty && model.activePlayers.length > 1)
            GameStateEffect.needWinnerSelection(
              possibleWinnersUid: model.possibleWinnersUids,
              isSideSpot: false,
            ),
        ],
      );

  GameStateModel _removeEffects(GameStateModel model) =>
      model.copyWith(effects: []);

  // Notifing the client of winner or requirement of winners selection
  GameStateModel _selectWinnersOnShowdown({
    required GameStateModel model,
  }) {
    GameStateModel model2;

    // 1.1 If win from folds, show 1 winner
    final winFromFold = model.activePlayers.length == 1;

    if (winFromFold) {
      final winner = model.activePlayers.first;
      final totalBets = model.sessionState.bets.values.sum;
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
          GameStateEffect.needWinnerSelection(
            possibleWinnersUid: model.possibleWinnersUids,
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

    // Sorted bets set
    List<int> bets =
        sessionState.bets.values.toSet().where((b) => b > 0).toList()..sort();

    // Iterate over each bet value
    logs.writeLog('GameSM: distrubution bets $bets');
    for (var i = 0; i < bets.length; i++) {
      final bid = bets[i];

      logs.writeLog('GameSM: distrubution $bid');
      if (bid <= 0) continue;

      // Side-spot check
      final possibleWinnersUids = model.possibleWinnersUids;
      if (winners.isEmpty && possibleWinnersUids.length > 1) {
        logs.writeLog('GameSM: need to call winnerChooseDialog');

        return model.copyWith(
          effects: [
            GameStateEffect.needWinnerSelection(
              possibleWinnersUid: possibleWinnersUids,
              isSideSpot: true,
            )
          ],
        );
      }

      // The amount that will be distributed among the winners for this bet
      int sumToDivide = 0;

      // We go through the bets and check if anyone has placed a given bet.
      for (final entry in sessionState.bets.entries) {
        // If a guy placed such a bet
        if (entry.value >= bid) {
          // If not a winner, then we contribute it to the general bank.
          if (!winners.contains(entry.key)) {
            logs.writeLog(
              'GameSM: ${entry.key} not winner, increase dividingSum',
            );
            sumToDivide += bid;
          } else {
            logs.writeLog('GameSM: ${entry.value} is winner bet, returning');
            // If this is a winner, then he got his money back.
            final newBanks = Map.of(lobbyState.banks)
              ..update(entry.key, (value) => value + bid);

            lobbyState = lobbyState.copyWith(banks: newBanks);
          }
        }
      }
      logs.writeLog('GameSM: sumToDivide $sumToDivide');

      // End the loop if there's a remainder and there are no more players
      // Return the money to the player who bet the most
      if (winners.isEmpty) {
        final newBanks = Map.of(lobbyState.banks);

        for (final player in model.activePlayers) {
          newBanks.update(player.uid,
              (value) => value + (sessionState.bets[player.uid] ?? 0));
        }
        lobbyState = lobbyState.copyWith(banks: newBanks);

        return model.copyWith(
          lobbyState: lobbyState,
          effects: [],
        );
      }

      final winnersCount = winners.length;

      // The divided spoils are divided among the winners, and only those who are still in the game
      for (final winnerUid in winners) {
        final bet = sessionState.bets[winnerUid] ?? 0;

        if (bet > 0) {
          logs.writeLog(
            'GameSM: adding ${sumToDivide ~/ winnersCount} to $winnerUid',
          );
          final newBanks = Map.of(lobbyState.banks)
            ..update(
              winnerUid,
              (value) => value + (sumToDivide ~/ winnersCount),
            );
          lobbyState = lobbyState.copyWith(banks: newBanks);
        }
      }

      // Subtract the processed rate from the list of bets
      for (int m = 0; m < bets.length; m++) {
        bets[m] -= bid;
      }
      logs.writeLog('GameSM: distrubution new bets $bets');

      // We exclude from the count the players whose bet was equal to the wagered one

      final newBets = Map.of(sessionState.bets);

      for (final player in model.lobbyState.players) {
        if (sessionState.bets[player.uid] == bid) {
          winners.remove(player.uid);
        }

        // We reduce the players' bets, since the amount equal to [bid] has already been played
        newBets.update(
          player.uid,
          (value) {
            final newBet = value - bid;
            return newBet > 0 ? newBet : 0;
          },
          ifAbsent: () => 0,
        );
      }

      sessionState = sessionState.copyWith(
        bets: newBets,
      );

      model = GameStateModel(
        sessionState: sessionState,
        lobbyState: lobbyState,
        effects: [],
      );
    }

    return GameStateModel(
      lobbyState: lobbyState,
      sessionState: sessionState,
      effects: [],
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

    final model1 = model.copyWith(
      sessionState: model.sessionState.copyWith(
        bets: {},
        foldedPlayers: {},
        firstPlayerUid: null,
        currentPlayerUid: null,
        lapCounter: 0,
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

    GameStateModel processAntes({
      required GameStateModel model,
      required int dealerPosition,
      required int bigBlindPosition,
    }) {
      final anteType = model.lobbyState.anteType;
      final anteValue = model.lobbyState.anteValue;

      var updatedModel = model;

      if (anteType == AnteType.none || anteValue <= 0) {
        return updatedModel;
      } else if (anteType == AnteType.bigBlindAnte) {
        final bigBlindPlayer =
            updatedModel.lobbyState.players[bigBlindPosition];

        return processBetOrAllIn(
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

          updatedModel = processBetOrAllIn(
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

    editableModel = processAntes(
      model: editableModel,
      dealerPosition: dealerPosition,
      bigBlindPosition: bigBlindPosition,
    );

    // Small blind bet
    editableModel = processBetOrAllIn(
      modelToProcess: editableModel,
      player: currentLobby().players[smallBlindPosition],
      value: currentLobby().smallBlindValue,
    );

    // Big blind bet
    editableModel = processBetOrAllIn(
      modelToProcess: editableModel,
      player: currentLobby().players[bigBlindPosition],
      value: currentLobby().bigBlindValue,
    );

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

    final foldedPlayers = model.sessionState.foldedPlayers
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
}
