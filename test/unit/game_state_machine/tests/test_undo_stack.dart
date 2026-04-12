import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// Test: Multiple actions are undone correctly
void runMultipleUndoTest(
    ProviderContainer container, AppRepository repository) async {
  final players = createPlayers(3);
  final lobbyState =
      createLobbyState(players, gameState: GameStatusEnum.notStarted);
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future);

  // Step 1: Start game (notStarted -> preFlop)
  await notifier.startBetting();
  // Player 1 is Dealer/UTG, Player 2 is SB, Player 3 is BB
  var state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[0].uid);

  // Step 2: Player 1 calls
  await notifier.executeCall();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[1].uid);

  // Step 3: Player 2 calls
  await notifier.executeCall();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[2].uid);

  // Step 4: Player 3 checks (since everyone called BB)
  await notifier.executeCheck();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.flop);

  // Now we have 4 actions on the stack. Let's undo 3 times!

  // Undo Step 4
  await notifier.undoLastAction();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[2].uid);

  // Undo Step 3
  await notifier.undoLastAction();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[1].uid);

  // Undo Step 2
  await notifier.undoLastAction();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(state.sessionState.currentPlayerUid, players[0].uid);
}

/// Test: Undo all actions returns to initial state and disables undo
void runUndoUntilEmptyTest(
    ProviderContainer container, AppRepository repository) async {
  final players = createPlayers(3);
  final lobbyState =
      createLobbyState(players, gameState: GameStatusEnum.notStarted);
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future);

  // Assert initially cannot undo
  expect(notifier.canUndoAction, false);

  // Step 1: Start game (notStarted -> preFlop)
  await notifier.startBetting();
  var state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(notifier.canUndoAction, true);

  // Step 2: Player 1 calls
  await notifier.executeCall();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.sessionState.currentPlayerUid, players[1].uid);
  expect(notifier.canUndoAction, true);

  // Undo Step 2
  await notifier.undoLastAction();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.sessionState.currentPlayerUid, players[0].uid);
  expect(state.lobbyState.gameState, GameStatusEnum.preFlop);
  expect(notifier.canUndoAction, true);

  // Undo Step 1
  await notifier.undoLastAction();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.lobbyState.gameState, GameStatusEnum.notStarted);
  expect(notifier.canUndoAction, false); // Stack should be empty now
}
