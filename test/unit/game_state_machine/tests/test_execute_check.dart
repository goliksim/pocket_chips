import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// [CheckTest] on Pre-flop in Hand-Up case
/// Expect transition to Flop, Big Blind Player goes first
void runExecuteCheckHandUpBigBlindTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
    },
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[0].uid,
    currentPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeCheck();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(gameState: GameStatusEnum.flop),
  );
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      firstPlayerUid: players[1].uid,
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// [CheckTest] performing by Big Blind Player in Hand-Up case
/// 2 Players is in AllIn
/// Expect transition to Flop, Big Blind Player goes first
void runExecuteCheckHandUpBigBlind2Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 60,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[3].uid,
    currentPlayerUid: players[2].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 10,
      players[2].uid: 40,
      players[3].uid: 10,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeCheck();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      firstPlayerUid: players[2].uid,
      currentPlayerUid: players[2].uid,
    ),
  );
  expect(
    gameState.lobbyState,
    lobbyState.copyWith(gameState: GameStatusEnum.flop),
  );
}
