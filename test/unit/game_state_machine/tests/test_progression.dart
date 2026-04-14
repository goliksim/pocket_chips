import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/blind_progression_model.dart';
import 'package:pocket_chips/domain/models/game/game_progression_state.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_game_settings_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/game_logic_service.dart';

import '../../test_utils.dart';

void runInitializationWithSavedHandsProgressionTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.gameBreak,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.everyNHands,
        progressionInterval: 5,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final gameSessionState = GameSessionState(
    bets: const {},
    foldedPlayers: const {},
    lapCounter: 0,
    progressionState: const GameProgressionState(
      currentLevelIndex: 1,
      handsFromLevelStart: 2,
    ),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameState = await container.read(gameStateMachineProvider.future);

  expect(gameState.sessionState.progressionState,
      const GameProgressionState(currentLevelIndex: 1));
  expect(gameState.currentSmallBlindValue, 20);
}

void runEveryNHandsProgressionTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    defaultBank: 1000,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.everyNHands,
        progressionInterval: 1,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => GameSessionState.initial());

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();
  await gameStateMachine.executeFold();

  final breakdownState = gameStateMachine.state.requireValue;
  expect(
    breakdownState.sessionState.progressionState,
    const GameProgressionState(currentLevelIndex: 1),
  );
  expect(breakdownState.currentSmallBlindValue, 20);

  await gameStateMachine.startBetting();

  final nextHandState = gameStateMachine.state.requireValue;
  expect(
    nextHandState.sessionState.bets.values.toList()..sort(),
    [20, 40],
  );
}

/// Test: Timed progression advances on rebuild if time passed, and clamps to last level
void runTimedProgressionAdvanceOnRestoreTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.gameBreak,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.everyNMinutes,
        progressionInterval: 5,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final gameSessionState = GameSessionState(
    bets: const {},
    foldedPlayers: const {},
    lapCounter: 0,
    progressionState: GameProgressionState(
      currentLevelIndex: 0,
      levelTimerStartMsUtc: DateTime.now()
          .toUtc()
          .subtract(const Duration(minutes: 6)) // Interval is 5, so 6 is past
          .millisecondsSinceEpoch,
    ),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameState = await container.read(gameStateMachineProvider.future);

  expect(
    gameState.sessionState.progressionState.currentLevelIndex,
    1,
  );
  expect(gameState.sessionState.progressionState.levelTimerStartMsUtc, isNull);
  expect(gameState.currentSmallBlindValue, 20);
}

// Test: Manual progression keeps level on rebuild
void runManualProgressionKeptOnRebuildTest(
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.notStarted,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.manual,
        progressionInterval: null,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  GameSessionState? savedSessionState;
  final mock = repository as dynamic;

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState()).thenAnswer(
    (_) async => savedSessionState ?? GameSessionState.initial(),
  );
  when(mock.updateLobbyState(any)).thenAnswer((_) async {});
  when(mock.updateGameSessionState(any)).thenAnswer((invocation) async {
    savedSessionState =
        invocation.positionalArguments.first as GameSessionState;
  });

  final container1 = ProviderContainer.test(
    overrides: [
      appRepositoryProvider.overrideWithValue(repository),
    ],
  );

  try {
    final gameStateMachine = container1.read(gameStateMachineProvider.notifier);

    await gameStateMachine.future;
    await gameStateMachine.nextLevel();

    expect(savedSessionState?.progressionState.currentLevelIndex, 1);
    expect(gameStateMachine.state.requireValue.currentSmallBlindValue, 20);
  } finally {
    container1.dispose();
  }

  final container2 = ProviderContainer.test(
    overrides: [
      appRepositoryProvider.overrideWithValue(repository),
    ],
  );

  try {
    final gameState = await container2.read(gameStateMachineProvider.future);

    expect(savedSessionState?.progressionState.currentLevelIndex, 1);
    expect(gameState.sessionState.progressionState.currentLevelIndex, 1);
    expect(gameState.currentSmallBlindValue, 20);
  } finally {
    container2.dispose();
  }
}

/// Test: Manual progression clamps to valid levels on rebuild
void runManualProgressionClampOnRestoreTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.gameBreak,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.manual,
        progressionInterval: null,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final sessionState = GameSessionState(
    bets: const {},
    foldedPlayers: const {},
    lapCounter: 0,
    progressionState: const GameProgressionState(currentLevelIndex: 4),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState()).thenAnswer((_) async => sessionState);

  final gameState = await container.read(gameStateMachineProvider.future);

  expect(gameState.sessionState.progressionState.currentLevelIndex, 1);
  expect(gameState.currentSmallBlindValue, 20);
}

/// Test: Every N Hands progression doesn't advance past last level
void runEveryNHandsLastLevelNoAdvanceTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.gameBreak,
    defaultBank: 1000,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.everyNHands,
        progressionInterval: 2,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final sessionState = GameSessionState(
    bets: const {},
    foldedPlayers: const {},
    lapCounter: 0,
    progressionState: const GameProgressionState(currentLevelIndex: 1),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState()).thenAnswer((_) async => sessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;
  expect(gameState.lobbyState.gameState, GameStatusEnum.gameBreak);
  expect(
    gameState.sessionState.progressionState,
    const GameProgressionState(currentLevelIndex: 1),
  );
  expect(gameState.currentSmallBlindValue, 20);
}

// Test: Manual progression doesn't change during active hand
void runManualProgressionIgnoredDuringHandTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.preFlop,
    defaultBank: 1000,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.manual,
        progressionInterval: null,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final sessionState = GameSessionState(
    bets: {
      players[0].uid: 10,
      players[1].uid: 20,
    },
    foldedPlayers: const {},
    lapCounter: 0,
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[0].uid,
    progressionState: const GameProgressionState(currentLevelIndex: 0),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState()).thenAnswer((_) async => sessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.nextLevel();

  final gameState = gameStateMachine.state.requireValue;
  expect(gameState.sessionState.progressionState.currentLevelIndex, 0);
  expect(gameState.currentSmallBlindValue, 10);
}

// Test: Manual progression doesn't advance past last level
void runManualProgressionStaysOnLastLevelTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    gameState: GameStatusEnum.gameBreak,
  ).copyWith(
    settings: LobbyGameSettingsModel(
      progression: BlindProgressionModel.pro(
        progressionType: BlindProgressionType.manual,
        progressionInterval: null,
        levels: const [
          BlindLevelModel(smallBlind: 10),
          BlindLevelModel(smallBlind: 20),
        ],
      ),
    ),
  );
  final sessionState = GameSessionState(
    bets: const {},
    foldedPlayers: const {},
    lapCounter: 0,
    progressionState: const GameProgressionState(currentLevelIndex: 1),
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState()).thenAnswer((_) async => sessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.nextLevel();

  final gameState = gameStateMachine.state.requireValue;
  expect(gameState.sessionState.progressionState.currentLevelIndex, 1);
  expect(gameState.currentSmallBlindValue, 20);
}

/// Test: Manual progression saves to Undo stack
void runManualProgressionUndoStackTest(
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

  final undoStackInitial = container.read(gamePreviousStateNotifierProvider);
  final initialCount = undoStackInitial.length;

  await notifier.nextLevel();

  final undoStackAfter = container.read(gamePreviousStateNotifierProvider);
  expect(undoStackAfter.length, initialCount + 1); // SHOULD save to stack
}
