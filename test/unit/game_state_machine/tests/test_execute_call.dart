import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// [CallTest] on second lap, we are calling the raise
/// All bets are equal
/// Jump to the next street without waiting for the turn to finish.
void runExecuteCallFinalAfterRaiseTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.flop,
    banks: {
      players[0].uid: 420,
      players[1].uid: 420,
      players[2].uid: 420,
      players[3].uid: 460,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {},
    currentPlayerUid: players[3].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 80,
      players[1].uid: 80,
      players[2].uid: 80,
      players[3].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCall();

  final finalState = gameStateMachine.state.requireValue;

  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.turn,
      banks: {
        players[0].uid: 420,
        players[1].uid: 420,
        players[2].uid: 420,
        players[3].uid: 420,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {
        players[0].uid: 80,
        players[1].uid: 80,
        players[2].uid: 80,
        players[3].uid: 80,
      },
      foldedPlayers: {},
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// [CallTest] after AllIn by Big Blind Player
/// Expect call value equal to big blind
void runExecuteCallAfterBBAITest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 100,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 400,
      players[1].uid: 0,
      players[2].uid: 500,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 2,
    foldedPlayers: {},
    currentPlayerUid: players[2].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 120,
      players[1].uid: 120,
      players[2].uid: 80,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCall();

  final finalState = gameStateMachine.state.requireValue;

  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.turn,
      banks: {
        players[0].uid: 380,
        players[1].uid: 380,
        players[2].uid: 380,
        players[3].uid: 380,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {
        players[0].uid: 120,
        players[1].uid: 120,
        players[2].uid: 120,
        players[3].uid: 120,
      },
      foldedPlayers: {},
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// [CallTest] on third lap after raise and re-raise
/// All bets are equal
/// Jump to the next street without waiting for the turn to finish.
void runExecuteCallFinalAfterReRaiseTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.flop,
    banks: {
      players[0].uid: 380,
      players[1].uid: 380,
      players[2].uid: 420,
      players[3].uid: 380,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 2,
    foldedPlayers: {},
    currentPlayerUid: players[2].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 120,
      players[1].uid: 120,
      players[2].uid: 80,
      players[3].uid: 120,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCall();

  final finalState = gameStateMachine.state.requireValue;

  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.turn,
      banks: {
        players[0].uid: 380,
        players[1].uid: 380,
        players[2].uid: 380,
        players[3].uid: 380,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {
        players[0].uid: 120,
        players[1].uid: 120,
        players[2].uid: 120,
        players[3].uid: 120,
      },
      foldedPlayers: {},
      currentPlayerUid: players[1].uid,
    ),
  );
}
