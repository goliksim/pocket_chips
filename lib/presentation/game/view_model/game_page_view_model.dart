import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../domain/model_holders/game_state_machine/game_state_machine.dart';
import '../../../domain/models/game/blind_level_model.dart';
import '../../../domain/models/game/blind_progression_model.dart';
import '../../../domain/models/game/game_progression_state.dart';
import '../../../domain/models/game/game_state_effect.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/game/game_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/event_push_service/handlers/event_handler.dart';
import '../../../services/event_push_service/promotion_service.dart';
import '../../../services/game_logic_service.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/logs.dart';
import '../view_state/game_page_view_state.dart';
import '../view_state/game_player_item.dart';
import '../view_state/game_table_state.dart';
import '../widgets/game_contol/view_model/game_control_view_model.dart';
import '../widgets/game_contol/view_state/game_control_result.dart';
import '../widgets/game_contol/view_state/game_page_control_state.dart';
import '../widgets/winner_page/view_state/possible_winner_item.dart';
import '../widgets/winner_page/view_state/winner_choice_args.dart';

class GamePageViewModel extends AsyncNotifier<GamePageViewState>
    implements GameControlViewModel {
  GameStateMachine get _gameStateMachine =>
      ref.read(gameStateMachineProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  PromotionManager get _promotionManager => ref.read(promotionManagerProvider);
  DateTime get _nowUtc => ref.read(currentTimeProvider)();

  Timer? _minuteRefreshTimer;

  GamePageViewState get viewState => state.requireValue;

  @override
  FutureOr<GamePageViewState> build() async {
    logs.writeLog('GameVM: BUILDING STATE');
    ref.onDispose(_disposeMinuteRefreshTimer);

    final gameModel = await ref.watch(gameStateMachineProvider.future);
    final gameState = gameModel.lobbyState.gameState;
    final players = gameModel.lobbyState.players;

    _syncMinuteRefreshTimer(gameModel);

    final effects = gameModel.effects;
    if (effects.isNotEmpty) {
      effects.forEach(
        (effect) => _executeEffect(
          effect: effect,
          stateModel: gameModel,
        ),
      );
    }

    // Showing add in the end of game
    if (state.value?.gameStatus != null &&
        gameModel.lobbyState.gameState == GameStatusEnum.gameBreak) {
      _promotionManager.maybeShowPromotion(
        types: [
          EventType.donation,
          EventType.advertisement,
        ],
        delay: Duration(milliseconds: 1750),
      );
    }

    return GamePageViewState(
      controlState: _getControlState(gameModel),
      tableState: GameTableState(
        players: players
            .map((p) => GamePlayerItem(
                  uid: p.uid,
                  name: p.name,
                  assetUrl: p.assetUrl,
                  isDealer: p.uid == gameModel.lobbyState.dealerId,
                  isCurrent: p.uid == gameModel.sessionState.currentPlayerUid,
                  isFolded:
                      gameModel.sessionState.foldedPlayers.contains(p.uid),
                  bank: gameModel.lobbyState.banks[p.uid] ?? 0,
                  bet: gameModel.sessionState.bets[p.uid] ?? 0,
                ))
            .toList(),
        // TODO: players noise offset
        smallBlindValue: gameModel.currentSmallBlindValue,
        showProgression:
            gameModel.lobbyState.settings.progression.levels.length > 1 &&
                gameModel.sessionState.progressionState.currentLevelIndex <
                    gameModel.lobbyState.settings.progression.levels.length - 1,
        progressionType:
            gameModel.lobbyState.settings.progression.progressionType,
        anteType: gameModel.currentAnteType,
        anteValue: gameModel.currentAnteValue,
        progressionLevel:
            gameModel.sessionState.progressionState.currentLevelIndex + 1,
        leftInterval: _getIntervalLeft(gameModel.sessionState.progressionState),
      ),
      gameStatus: gameState,
      currentPlayerName: gameModel.currentPlayer?.name,
      canEditPlayer: gameState.canEditPlayers,
    );
  }

  bool get canUndoAction => _gameStateMachine.canUndoAction;

  Future<void> undoLastAction() => _gameStateMachine.undoLastAction();

  Future<void> openPlayerEditor(String? playerUid) async {
    if (state.requireValue.canEditPlayer) {
      await _navigationManager.showPlayerEditor(playerUid);

      //Rebuild after lobbyEditing
      _gameStateMachine.runBuild();
    }
  }

  Future<void> showSavedPlayers() async {
    await _navigationManager.showSavedPlayers();

    //Rebuild after lobbyEditing
    _gameStateMachine.runBuild();
  }

  void pop() => _navigationManager.pop();

  @override
  GamePageControlState get controlsState => state.requireValue.controlState;

  @override
  Future<void> onControlAction(GameControlResult result) async => result.map(
        raise: (result) => _gameStateMachine.executeRaise(result.raiseValue),
        allIn: (_) => _gameStateMachine.executeAllIn(),
        call: (_) => _gameStateMachine.executeCall(),
        check: (_) => _gameStateMachine.executeCheck(),
        fold: (_) => _gameStateMachine.executeFold(),
      );

  @override
  Future<void> openSettings() async {
    await _navigationManager.showLobbySettings();

    //Rebuild after lobbyEditing
    _gameStateMachine.runBuild();
  }

  @override
  Future<void> startBetting() async => _gameStateMachine.startBetting();

  @override
  Future<void> increaseGameLevel() async => _gameStateMachine.nextLevel();

  GamePageControlState _getControlState(GameStateModel gameModel) {
    try {
      final gameState = gameModel.lobbyState.gameState;
      final currentPlayerUid = gameModel.sessionState.currentPlayerUid;

      switch (gameState) {
        case GameStatusEnum.notStarted:
        case GameStatusEnum.gameBreak:
          return GamePageControlState.breakdown(
            canStartBetting: gameModel.canStartOrContinueGame,
            canIncreaseLevel: gameModel.canIncreaseLevel,
          );
        case GameStatusEnum.showdown:
          return GamePageControlState.showdown();

        default:
          break;
      }

      if (currentPlayerUid == null) {
        return GamePageControlState.showdown();
      }

      final maxBet = gameModel.sessionState.bets.values.maxOrNull ?? 0;
      final currentBank =
          gameModel.lobbyState.banks[gameModel.sessionState.currentPlayerUid] ??
              0;
      final currentBet = gameModel
              .sessionState.bets[gameModel.sessionState.currentPlayerUid] ??
          0;

      final (minRaiseValue, raiseIsAllIn) =
          gameModel.calculateRaiseValue(currentPlayerUid);

      final (callValue, callIsAllIn) =
          gameModel.calculateCallValue(currentPlayerUid);

      final allowCustomBets = gameModel.lobbyState.settings.allowCustomBets;

      final bool canCheck = (currentBet == maxBet);
      final bool canRaise;
      final bool canAllIn;

      final int minPossibleBet;
      final int maxPossibleBet = currentBank;
      final int minRuleBet = [maxPossibleBet, minRaiseValue].min;

      if (allowCustomBets) {
        canRaise = !callIsAllIn;
        canAllIn = false;
        minPossibleBet = callValue;
      } else {
        canRaise = !callIsAllIn && (currentBank > minRaiseValue);
        canAllIn = raiseIsAllIn;
        minPossibleBet = minRaiseValue;
      }

      final isFirstBet =
          gameModel.checkBidsEqual() && gameState != GameStatusEnum.preFlop;

      return GamePageControlState.active(
        raiseState: RaiseControlState(
          canRaise: canRaise,
          raiseIsAllIn: canAllIn,
          isFirstBet: isFirstBet,
          maxPossibleBet: maxPossibleBet,
          minPossibleBet: minPossibleBet,
          minRuleBet: minRuleBet,
          currentBet: currentBet,
        ),
        mainState: canCheck
            ? MainControlState.check()
            : MainControlState.call(
                callIsAllIn: callIsAllIn,
                callValue: callValue,
              ),
      );
    } catch (e) {
      throw Exception();
    }
  }

  int? _getIntervalLeft(GameProgressionState progressionState) =>
      progressionState.handsUntilNextLevel ??
      progressionState.minutesUntilNextLevelAt(_nowUtc);

  Future<void> _executeEffect({
    required GameStateEffect effect,
    required GameStateModel stateModel,
  }) async {
    effect.map(
      error: (effect) {
        logs.writeLog('GameVM: showing error notification');
        switch (effect.type) {
          case GameStateErrorType.fewPlayers:
            _toastManager.showToast(_strings.toast_moreplay);
            break;
        }
      },
      hasWinner: (effect) {
        final winner = stateModel.lobbyState.players
            .firstWhere((p) => p.uid == effect.winnerUid);
        logs.writeLog('GameVM: showing winner - ${winner.name}');

        _navigationManager.showWinner(winner);
      },
      needWinnerSelection: (effect) async {
        logs.writeLog('GameVM: calling winner selector');

        final players = stateModel.lobbyState.players
            .where((p) => effect.possibleWinnersUid.contains(p.uid));

        final winners = await _navigationManager.showWinnerChooseDialog(
          WinnerChoiceArgs(
            title: effect.isSideSpot ? _strings.game_win4 : _strings.game_win3,
            possibleWinners: players
                .map(
                  (p) => PossibleWinnerItem(
                    name: p.name,
                    assetUrl: p.assetUrl,
                    uid: p.uid,
                    bid: stateModel.sessionState.bets[p.uid] ?? 0,
                  ),
                )
                .toList(),
          ),
        );

        if (winners != null && winners.isNotEmpty) {
          _gameStateMachine.executeWinnerSelection(
            selectedWinners: winners,
          );
        }
      },
    );
  }

  void _syncMinuteRefreshTimer(GameStateModel gameModel) {
    final progressionState = gameModel.sessionState.progressionState;
    final shouldRefreshEveryMinute =
        gameModel.lobbyState.settings.progression.progressionType ==
                BlindProgressionType.everyNMinutes &&
            progressionState.nextLevelAtEpochMsUtc != null;

    if (!shouldRefreshEveryMinute) {
      _disposeMinuteRefreshTimer();
      return;
    }

    _minuteRefreshTimer?.cancel();

    _minuteRefreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) {
        if (ref.mounted) {
          state = AsyncData(
            state.requireValue.copyWith(
              tableState: state.requireValue.tableState.copyWith(
                leftInterval: _getIntervalLeft(progressionState),
              ),
            ),
          );
        }
      },
    );
  }

  void _disposeMinuteRefreshTimer() {
    _minuteRefreshTimer?.cancel();
    _minuteRefreshTimer = null;
  }
}
