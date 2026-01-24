//ОСНОВНАЯ ИГРОВАЯ ЛОГИКА
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigation/navigation_manager.dart';
import '../../di/domain_managers.dart';
import '../../di/model_holders.dart';
import '../../di/repositories.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';
import '../../services/event_push_service/handlers/event_handler.dart';
import '../../services/event_push_service/promotion_service.dart';
import '../../services/game_logic_service.dart';
import '../../services/toast_manager.dart';
import '../../utils/logs.dart';
import '../models/game/game_session_state.dart';
import '../models/game/game_state_enum.dart';
import '../models/game/game_state_model.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_id.dart';
import '../models/player/player_model.dart';
import 'lobby_state_holder.dart';

class GameStateMachine extends AsyncNotifier<GameStateModel> {
  LobbyStateHolder get _lobbyStateHolder =>
      ref.read(lobbyStateHolderProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  PromotionManager get _promotionManager => ref.read(promotionManagerProvider);

  @override
  FutureOr<GameStateModel> build() async {
    logs.writeLog('GameSM: READ DATA AND BUILD STATE');

    final lobbyState = await ref.watch(lobbyStateHolderProvider.future);

    final sessionState = lobbyState.gameState.isStarted
        ? await ref.read(appRepositoryProvider).getGameSessionState()
        : null;

    final finalSessionState = sessionState ?? GameSessionState.initial();

    final foldedByBank = <GameStatusEnum>{
      GameStatusEnum.notStarted,
      GameStatusEnum.gameBreak
    }.contains(lobbyState.gameState)
        ? lobbyState.banks.entries
            .map((e) => e.value <= 0 ? e.key : null)
            .nonNulls
            .toSet()
        : <String>{};

    final finalFoldedPlayers = finalSessionState.foldedPlayers
      ..addAll(foldedByBank);

    return GameStateModel(
      lobbyState: lobbyState,
      sessionState: finalSessionState.copyWith(
        foldedPlayers: finalFoldedPlayers,
      ),
    );
  }

  //Player controls
  Future<void> startBetting() async {
    final currentModel = state.requireValue;

    if (!currentModel.canStartOrContinueGame) {
      //TODO: remove navigation from StateHolder
      logs.writeLog('GameSM: cannot start betting');
      _toastManager.showToast(_strings.toast_moreplay);
      return;
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

    // 3. Update the game
    await _updateGame(stateAfterBlinds);
  }

  Future<void> executeRaise(int raiseValue) => _executeBet(raiseValue);

  Future<void> executeAllIn() {
    final currentModel = state.requireValue;
    final currentPlayerUid = _getCurrentPlayerUid(currentModel);

    final bank = currentModel.lobbyState.banks[currentPlayerUid] ?? 0;

    logs.writeLog('GameSM: executeAllIn $bank');
    return _executeBet(bank);
  }

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

  Future<void> executeCheck() async {
    logs.writeLog('GameSM: executeCheck');

    final nextState = _calculateNextPlayerState(state.requireValue);
    await _updateGame(nextState);
  }

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

  // Новый круг
  Future<void> showWinnersAndEndLap({
    required GameStateModel model,
  }) async {
    // 1. Set state to showdown
    final model1 = model.copyWith(
      lobbyState: model.lobbyState.copyWith(
        gameState: GameStatusEnum.showdown,
      ),
      sessionState: model.sessionState.copyWith(
        currentPlayerUid: null,
      ),
    );

    GameStateModel model2;

    // 2.1 If win from folds, show 1 winner
    final winFromFold = model1.activePlayers.length == 1;

    if (winFromFold) {
      final winner = model1.activePlayers.first;
      final totalBets = model1.sessionState.bets.values.sum;
      final newBanks = Map.of(model1.lobbyState.banks)
        ..update(winner.uid, (value) => value + totalBets);

      model2 = model1.copyWith(
        lobbyState: model1.lobbyState.copyWith(
          banks: newBanks,
        ),
      );

      //TODO: remove navigation from StateHolder
      unawaited(
        _navigationManager.showWinner(winner),
      );
    } else {
      // 2.2. Else need to select winner
      logs.writeLog('Call WinnerChooseWindow');

      //TODO: remove navigation from StateHolder
      final markedWinners = await _navigationManager.showWinnerChooseDialog(
        WinnerChoiceArgs(
          title: _strings.game_win3,
          possibleWinners: model1.possibleWinners,
        ),
      );

      if (markedWinners == null) {
        throw Exception('needToSelectWinners');
      }

      model2 = await _moneyDistribution(
        model: model1,
        winners: markedWinners,
      );
    }

    // 3. Reset folded states and bets
    final model3 = _toBreakdown(model: model2);

    await _updateGame(model3);

    _promotionManager.maybeShowPromotion(
      types: [
        EventType.donation,
        EventType.advertisement,
      ],
      delay: Duration(milliseconds: 1750),
    );
  }

  String _getCurrentPlayerUid(GameStateModel model) {
    final currentPlayerUid = model.sessionState.currentPlayerUid;

    if (currentPlayerUid == null) {
      throw Exception('Run _getCurrentPlayerUid with no player');
    }

    return currentPlayerUid;
  }

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

  Future<GameStateModel> _moneyDistribution({
    required GameStateModel model,
    required Set<String> winners,
  }) async {
    // Упорядоченное множество ставок
    logs.writeLog('GameSM: distrubuteMoney $winners');

    var lobbyState = model.lobbyState;
    var sessionState = model.sessionState;

    List<int> bets = sessionState.bets.values.toSet().toList()..sort();

    if (bets[0] == 0) {
      bets.removeAt(0);
    }

    // Проходимся по каждому разному значению ставок
    logs.writeLog('GameSM: distrubution bets $bets');
    for (int bid in bets) {
      logs.writeLog('GameSM: distrubution $bid');
      if (bid <= 0) continue;

      // Проверка на сайд-спот
      if (winners.isEmpty && model.possibleWinners.length > 1) {
        logs.writeLog('GameSM: call winnerChooseDialog');
        final newWinners = await _navigationManager.showWinnerChooseDialog(
          WinnerChoiceArgs(
            title: _strings.game_win4,
            possibleWinners: model.possibleWinners,
          ),
        );

        if (newWinners == null) {
          throw Exception('needToSelectWinner');
        }

        return _moneyDistribution(
          model: model,
          winners: newWinners,
        );
      }

      // Та сумма которая будет распределяться по победителям для данной ставки
      int sumToDivide = 0;

      // Проходимся по ставкам и проверяем, ставил ли кто-то данную ставку
      for (final entry in sessionState.bets.entries) {
        // Если челик такую ставку поставил
        if (entry.value >= bid) {
          // Если не победитель, то вносим ее в общий банк
          if (!winners.contains(entry.key)) {
            logs.writeLog(
                'GameSM: ${entry.key} not winner, increase dividingSum');
            sumToDivide += bid;
          } else {
            logs.writeLog('GameSM: ${entry.value} is winner bet, returning');
            // Если это победитель, то он свое вернул
            final newBanks = Map.of(lobbyState.banks)
              ..update(entry.key, (value) => value + bid);

            lobbyState = lobbyState.copyWith(banks: newBanks);
          }
        }
      }
      logs.writeLog('GameSM: sumToDivide $sumToDivide');

      // Заканчиваем цикл если остаток остался, а челиксы закончились
      // Возвращаем деньги тому, кто поставил больше всех бабок
      if (winners.isEmpty) {
        //_pop();
        final newBanks = Map.of(lobbyState.banks);
        for (final player in model.activePlayers) {
          newBanks.update(player.uid,
              (value) => value + (sessionState.bets[player.uid] ?? 0));
        }
        lobbyState = lobbyState.copyWith(banks: newBanks);

        return model.copyWith(lobbyState: lobbyState);
      }

      final winnersCount = winners.length;

      // Разделенная добыча делится на победителей, причем тока тех, кто еще в игре
      for (final winnerUid in winners) {
        final bet = sessionState.bets[winnerUid] ?? 0;

        if (bet > 0) {
          logs.writeLog(
              'GameSM: adding ${sumToDivide ~/ winnersCount} to $winnerUid');
          final newBanks = Map.of(lobbyState.banks)
            ..update(
              winnerUid,
              (value) => value + (sumToDivide ~/ winnersCount),
            );
          lobbyState = lobbyState.copyWith(banks: newBanks);
        }
      }

      // Вычитаем отработанную ставку из списка
      for (int m = 0; m < bets.length; m++) {
        bets[m] -= bid;
      }
      logs.writeLog('GameSM: distrubution new bets $bets');

      // Выключаем из посчета игроков, чья ставка была равно отработанной

      final newBets = Map.of(sessionState.bets);

      for (final player in model.lobbyState.players) {
        if (sessionState.bets[player.uid] == bid) {
          winners.remove(player.uid);
        }

        // Уменьшаем ставки игроков, так как сумма равная [bid] уже отыграла
        newBets.update(
          player.uid,
          (value) => value - bid,
          ifAbsent: () => 0,
        );
      }

      sessionState = sessionState.copyWith(
        bets: newBets,
      );

      model = model.copyWith(
        sessionState: sessionState,
        lobbyState: lobbyState,
      );
    }

    return model.copyWith(
      lobbyState: lobbyState,
      sessionState: sessionState,
    );
  }

  // Переходы между игроками

  GameStateModel _calculateNextPlayerState(GameStateModel currentModel) {
    logs.writeLog('GameSM: finding next player state');
    var currentSession = currentModel.sessionState;
    final currentLobby = currentModel.lobbyState;

    final bidsEqual = _checkBidsEqual(currentModel);

    // 1. FORCE SHOWDOWN IF BETS EQUAL AND ONLY ONE LAST WITH MONEY
    if (bidsEqual && currentModel.activePlayersWithMoneyCount <= 1) {
      logs.writeLog('GameSM: [CNPS] force to showdown');
      return currentModel.copyWith(
        lobbyState: currentLobby.copyWith(
          gameState: GameStatusEnum.showdown,
        ),
        sessionState: currentModel.sessionState.copyWith(
          currentPlayerUid: null,
        ),
      );
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

  // Ищем следующего игрока, скипаем фолд и олинщиков.
  // Повышаем круг, если нужно
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

  // Новая улица
  GameStateModel _calculateNewStreet(GameStateModel currentModel) {
    final nextStreet = currentModel.lobbyState.gameState.next;

    logs.writeLog('GameSM: setup new street ${nextStreet.name}');

    final newLobbyState = currentModel.lobbyState.copyWith(
      gameState: currentModel.lobbyState.gameState.next,
    );

    // 1. RETURN CURRENT STATE IN SHOWDOWN
    if (nextStreet == GameStatusEnum.showdown) {
      logs.writeLog('GameSM: new street is showdown, returning to UI');
      return currentModel.copyWith(
        lobbyState: newLobbyState,
        sessionState: currentModel.sessionState.copyWith(
          currentPlayerUid: null,
        ),
      );
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
            'GameSM: first player in new street is ${localPlayer.name}');
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

    return model1.copyWith(
      lobbyState: model1.lobbyState.copyWith(
        dealerId: _getNewDealerUid(model: model1),
        gameState: GameStatusEnum.gameBreak,
      ),
    );
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

  // Первые ставки
  GameStateModel _processFirstBlinds(GameStateModel model) {
    logs.writeLog('GameSM: processing first blinds');

    var editableModel = model;
    LobbyStateModel currentLobby() => editableModel.lobbyState;
    GameSessionState currentSession() => editableModel.sessionState;

    GameStateModel processBetOrAllIn({
      required GameStateModel modelToProcess,
      required PlayerModel player,
      required int value,
    }) {
      final currentLobby = modelToProcess.lobbyState;

      final bank = currentLobby.banks[player.uid] ?? 0;

      return _processBet(
        model: modelToProcess,
        playerId: player.uid,
        // Ставка тех денег, что есть
        bid: bank < value ? bank : value,
      );
    }

    final dealerPosition = currentLobby()
        .players
        .indexWhere((p) => p.uid == currentLobby().dealerId);

    int bigBlindPosition = dealerPosition;

    (GameStateModel, int) makeBetByCondition({
      required GameStateModel model,
      required bool Function(PlayerId) condition,
      required int value,
      int initialOffset = 1,
    }) {
      final currentLobby = model.lobbyState;

      for (int i = initialOffset; i < currentLobby.players.length; i++) {
        int localIndex = (i + dealerPosition) % currentLobby.players.length;

        final localPlayer = currentLobby.players[localIndex];

        if (condition(localPlayer.uid)) {
          model = processBetOrAllIn(
            modelToProcess: editableModel,
            player: localPlayer,
            value: value,
          );

          return (model, localIndex);
        }
      }

      return (model, bigBlindPosition);
    }

    //Head up случай
    final isHandsUp = editableModel.activePlayersWithMoney.length == 2;

    // Ставим смолблайнд
    (editableModel, _) = makeBetByCondition(
      model: model,
      condition: (uid) => editableModel.isPlayerActive(uid),
      value: currentLobby().smallBlindValue,
      initialOffset: isHandsUp ? 0 : 1,
    );

    // Ставим бигблайнд
    (editableModel, bigBlindPosition) = makeBetByCondition(
      model: model,
      condition: (uid) => (editableModel.isPlayerActive(uid) &&
          (currentSession().bets[uid] ?? 0) == 0),
      value: currentLobby().bigBlindValue,
    );

    if (_checkBidsEqual(editableModel) &&
        editableModel.activePlayersWithMoneyCount <= 1) {
      logs.writeLog('GameSM: head-up showdown forcing');
      return editableModel.copyWith(
        lobbyState: currentLobby().copyWith(
          gameState: GameStatusEnum.showdown,
        ),
        sessionState: currentSession().copyWith(
          currentPlayerUid: null,
        ),
      );
    }

    // Ищем первого игрока
    for (int i = 1; i < currentLobby().players.length; i++) {
      int localIndex = (i + bigBlindPosition) % currentLobby().players.length;

      final localPlayer = currentLobby().players[localIndex];

      if (editableModel.isPlayerActive(localPlayer.uid)) {
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

  bool _checkBidsEqual(GameStateModel model) {
    final activePlayers = model.activePlayers;

    final bets = activePlayers.map((p) => model.sessionState.bets[p.uid] ?? 0);
    if (bets.isEmpty) return true;

    final maxBet = bets.max;

    for (final player in activePlayers) {
      final bid = model.sessionState.bets[player.uid] ?? 0;
      final bank = model.lobbyState.banks[player.uid] ?? 0;

      bool isEqual = (bid == maxBet);
      bool isAllIn = ((bid > 0) && (bank <= 0));

      if (!(isEqual || isAllIn)) {
        logs.writeLog('GameSM: bets are not equal');
        return false;
      }
    }

    logs.writeLog('GameSM: bets are equal');
    return true;
  }

  Future<void> _updateGame(GameStateModel newModel) async {
    logs.writeLog('GameSM: UPDATE GAME');
    state = AsyncData(newModel);

    await _lobbyStateHolder.updateLobby(newModel.lobbyState);

    try {
      await ref
          .read(appRepositoryProvider)
          .updateGameSessionState(newModel.sessionState);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении сессии: $e');
    }
  }
}
