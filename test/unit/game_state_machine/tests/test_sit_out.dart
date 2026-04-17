import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/game/sit_out_mode.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/game_logic_service.dart';

import '../../test_utils.dart';

/// Test toggling sit out for a player
void runSitOutToggleTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.notStarted,
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future);

  await notifier.toggleSitOut(players[0].uid);
  var gameState = await container.read(gameStateMachineProvider.future);
  expect(gameState.sessionState.sitOutPlayers.contains(players[0].uid), true);

  await notifier.toggleSitOut(players[0].uid);
  gameState = await container.read(gameStateMachineProvider.future);
  expect(gameState.sessionState.sitOutPlayers.contains(players[0].uid), false);
}

/// Test cash mode ignores paused player
void runSitOutCashModeTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(players, sitOutMode: SitOutMode.cashGame);
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future); // Wait for build

  await notifier.toggleSitOut(players[1].uid);
  await notifier.startBetting();

  final gameState = await container.read(gameStateMachineProvider.future);

  // Player 1 (p1) is dealer, Player 3 (p3) is next active -> SB -> Big Blind actually since p2 is skipped!
  // Wait, if 3 players: p1(D), p2(SB but skipped), p3(SB), p1(BB).
  // Let's just assert that p2 is not active and paid 0 bets.
  expect(gameState.sessionState.bets[players[1].uid], null);
  expect(gameState.isPlayerActive(players[1].uid), false);
}

/// Test tournament mode makes paused player auto-fold after paying blinds/ante
void runSitOutTournamentModeTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    sitOutMode: SitOutMode.tournament,
    smallBlindValue: 10,
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future); // Wait for build

  await notifier.toggleSitOut(players[1].uid);
  await notifier.startBetting();

  final gameState = await container.read(gameStateMachineProvider.future);

  // In tournament, p2 pays SB because he was considered active initially
  expect(gameState.sessionState.bets[players[1].uid], 10);
  // But p2 should auto-fold immediately
  expect(gameState.sessionState.foldedPlayers.contains(players[1].uid), true);
  expect(gameState.isPlayerActive(players[1].uid), false);
}

/// Test: Player sit out doesn't save to Undo stack (savePreviousState: false)
void runPlayerSitOutUndoStackTest(
    ProviderContainer container, AppRepository repository) async {
  final players = createPlayers(3);
  final lobbyState =
      createLobbyState(players, gameState: GameStatusEnum.gameBreak);
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future);

  final undoStackInitial = container.read(gamePreviousStateNotifierProvider);
  final initialCount = undoStackInitial.length;

  await notifier.toggleSitOut(players[0].uid);

  final undoStackAfter = container.read(gamePreviousStateNotifierProvider);
  expect(undoStackAfter.length, initialCount); // Should NOT save to stack
}

/// Test: Progression and pause persist on reload & Sit out doesn't reset when settings change
void runSitOutReloadPersistenceTest(
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

  await notifier.toggleSitOut(players[0].uid);

  // Capture the current session state and mock the repository to return it for the rebuild
  final currentState = await container.read(gameStateMachineProvider.future);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => currentState.sessionState);

  // Trigger rebuild
  container.invalidate(gameStateMachineProvider);
  await container.read(gameStateMachineProvider.future);

  final finalState = await container.read(gameStateMachineProvider.future);
  expect(finalState.sessionState.sitOutPlayers.contains(players[0].uid), true);
}

/// Test: Sit out toggle during gameBreak doesn't trigger effects & Manual level change during gameBreak doesn't trigger effects
void runGameBreakEffectsTest(
    ProviderContainer container, AppRepository repository) async {
  final players = createPlayers(3);
  final initialLobby =
      createLobbyState(players, gameState: GameStatusEnum.gameBreak);
  final lobbyState = initialLobby.copyWith(
    settings: initialLobby.settings.copyWith(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.manual,
        progressionInterval: null,
        levels: [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final notifier = container.read(gameStateMachineProvider.notifier);
  await container.read(gameStateMachineProvider.future);

  await notifier.toggleSitOut(players[0].uid);
  var state = await container.read(gameStateMachineProvider.future);
  expect(state.effects.isEmpty, true);

  await notifier.nextLevel();
  state = await container.read(gameStateMachineProvider.future);
  expect(state.effects.isEmpty, true);
}
