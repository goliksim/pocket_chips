import 'dart:math';

import '../../../../../app/navigation/navigation_manager.dart';
import '../../../../../domain/model_holders/game_state_machine.dart';
import '../../../../../domain/models/game/game_state_enum.dart';
import '../../../../../domain/models/game/game_state_model.dart';
import '../view_state/game_control_result.dart';
import '../view_state/game_page_control_state.dart';
import 'game_control_view_model.dart';

class GameControlViewModelImpl implements GameControlViewModel {
  final NavigationManager _navigationManager;
  final GameStateMachine _gameStateMachine;

  late GamePageControlState _viewState;

  GameControlViewModelImpl({
    required NavigationManager navigationManager,
    required GameStateMachine gameStateMachine,
  })  : _navigationManager = navigationManager,
        _gameStateMachine = gameStateMachine {
    _init();
  }

  @override
  GamePageControlState get controlsState => _viewState;

  void _init() {
    final gameModel = _gameStateMachine.stateModel;

    _viewState = _getControlState(gameModel);
  }

  @override
  Future<void> onControlAction(GameControlResult result) async => result.map(
        raise: (result) => _gameStateMachine.executeRaise(result.raiseValue),
        allIn: (_) => _gameStateMachine.executeAllIn(),
        call: (_) => _gameStateMachine.executeCall(),
        check: (_) => _gameStateMachine.executeCheck(),
        fold: (_) => _gameStateMachine.executeFold(),
      );

  @override
  Future<void> openSettings() => _navigationManager.showGameSettings();

  @override
  Future<void> startBetting() async => _gameStateMachine.startBetting();

  GamePageControlState _getControlState(GameStateModel gameModel) {
    final gameState = gameModel.lobbyState.gameState;

    final maxBet = gameModel.sessionState.bets.values.reduce(max);
    final currentBank =
        gameModel.lobbyState.banks[gameModel.sessionState.currentPlayerUid] ??
            0;
    final currentBet =
        gameModel.sessionState.bets[gameModel.sessionState.currentPlayerUid] ??
            0;

    final allCurrentPlayerMoney = currentBank + currentBet;
    final raiseBank = _gameStateMachine.calculateRaiseValue();
    final betBool = _gameStateMachine.checkBidsEqual();

    final currentPlayerCanSkip = (currentBet == maxBet); // или betBool
    final canRaise = allCurrentPlayerMoney > maxBet;
    final onlyAllInRaise = currentBank <= raiseBank;
    final isFirstBet = betBool && gameState != GameStatusEnum.preFlop;

    final maxPossibleBet = currentBank;
    final minPossibleBet = raiseBank;

    final callValue = _gameStateMachine.calculateCallValue();

    return gameState.isStarted
        ? GamePageControlState.active(
            raiseState: RaiseControlState(
              canRaise: canRaise,
              onlyAllInRaise: onlyAllInRaise,
              isFirstBet: isFirstBet,
              maxPossibleBet: maxPossibleBet,
              minPossibleBet: minPossibleBet,
            ),
            mainState: currentPlayerCanSkip
                ? MainControlState.check()
                : MainControlState.call(
                    callIsAllIn: !canRaise,
                    callValue: callValue,
                  ),
          )
        : GamePageControlState.breakdown(
            canStartBetting: gameModel.canStartOrContinueGame,
          );
  }
}
