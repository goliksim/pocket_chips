import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../domain/model_holders/game_state_machine.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/game/game_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/localization_extension.dart';
import '../../../services/game_logic_service.dart';
import '../../../utils/logs.dart';
import '../view_state/game_page_view_state.dart';
import '../view_state/game_player_item.dart';
import '../view_state/game_table_state.dart';
import '../widgets/game_contol/view_model/game_control_view_model.dart';
import '../widgets/game_contol/view_state/game_control_result.dart';
import '../widgets/game_contol/view_state/game_page_control_state.dart';

class GamePageViewModel extends AsyncNotifier<GamePageViewState>
    implements GameControlViewModel {
  GameStateMachine get _gameStateMachine =>
      ref.read(gameStateMachineProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  GamePageViewState get viewState => state.requireValue;

  @override
  FutureOr<GamePageViewState> build() async {
    logs.writeLog('GameVM: READ DATA AND BUILD STATE');

    final gameModel = await ref.watch(gameStateMachineProvider.future);
    final gameState = gameModel.lobbyState.gameState;
    final players = gameModel.lobbyState.players;

    if (gameState == GameStatusEnum.showdown) {
      logs.writeLog('GameVM: showing winner window');
      _gameStateMachine.showWinnersAndEndLap(model: gameModel);
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
        //tableRotationOffset: tableRotationOffset,
        smallBlindValue: gameModel.lobbyState.smallBlindValue,
      ),
      gameStatus: gameState,
      currentGameState: getGameStateName(
        strings: _strings,
        state: gameState,
      ),
      currentPlayerName: gameModel.currentPlayer?.name,
      canEditPlayer: gameState.canEditPlayers,
    );
  }

  // Временное изменение текста
  void changeGameStateText(GameStatusEnum enumValue) async {
    state = AsyncData(
      viewState.copyWith(
        currentGameState: getGameStateName(
          strings: _strings,
          state: enumValue,
        ),
      ),
    );
  }

  Future<void> openPlayerEditor(String? playerUid) async {
    if (state.requireValue.canEditPlayer) {
      return _navigationManager.showPlayerEditor(playerUid);
    }
  }

  Future<void> showSavedPlayers() => _navigationManager.showSavedPlayers();

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
  Future<void> openSettings() => _navigationManager.showLobbySettings();

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
          if (currentPlayerUid == null) {
            return GamePageControlState.showdown();
          }
          break;
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
}
