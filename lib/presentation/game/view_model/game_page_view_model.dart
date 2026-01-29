import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../domain/model_holders/game_state_machine/game_state_machine.dart';
import '../../../domain/models/game/game_state_effect.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/game/game_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
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

  GamePageViewState get viewState => state.requireValue;

  @override
  FutureOr<GamePageViewState> build() async {
    logs.writeLog('GameVM: BUILDING STATE');

    final gameModel = await ref.watch(gameStateMachineProvider.future);
    final gameState = gameModel.lobbyState.gameState;
    final players = gameModel.lobbyState.players;

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
        smallBlindValue: gameModel.lobbyState.smallBlindValue,
      ),
      gameStatus: gameState,
      currentGameState: _strings.getGameStateName(gameState),
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

  void pop() => _navigationManager.popPage();

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

  GamePageControlState _getControlState(GameStateModel gameModel) {
    try {
      final gameState = gameModel.lobbyState.gameState;
      final currentPlayerUid = gameModel.sessionState.currentPlayerUid;

      switch (gameState) {
        case GameStatusEnum.notStarted:
        case GameStatusEnum.gameBreak:
          return GamePageControlState.breakdown(
            canStartBetting: gameModel.canStartOrContinueGame,
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

      final (raiseBank, raiseIsAllIn) =
          gameModel.calculateRaiseValue(currentPlayerUid);

      final (callValue, callIsAllIn) =
          gameModel.calculateCallValue(currentPlayerUid);
      final betBool = gameModel.checkBidsEqual();

      final currentPlayerCanSkip = (currentBet == maxBet);
      final canRaise =
          !callIsAllIn && (currentBank > raiseBank || raiseIsAllIn);

      final isFirstBet = betBool && gameState != GameStatusEnum.preFlop;

      final maxPossibleBet = currentBank;
      final minPossibleBet = raiseBank;

      return GamePageControlState.active(
        raiseState: RaiseControlState(
          canRaise: canRaise,
          raiseIsAllIn: raiseIsAllIn,
          isFirstBet: isFirstBet,
          maxPossibleBet: maxPossibleBet,
          minPossibleBet: minPossibleBet,
          currentBet: currentBet,
        ),
        mainState: currentPlayerCanSkip
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
}
