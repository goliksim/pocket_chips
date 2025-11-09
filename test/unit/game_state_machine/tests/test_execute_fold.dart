import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';
import '../game_state_machine_test.mocks.dart';

/// Тест фолда игрока
void runExecuteFoldTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 80,
      players[1].uid: 60,
      players[2].uid: 100,
    },
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[0].uid,
    currentPlayerUid: players[0].uid,
    bets: {
      players[0].uid: 20,
      players[1].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;

  expect(gameState.lobbyState, lobbyState);
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[0].uid,
      },
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// Тест фолда последнего игрока при равных ставках, ожидаем перехода на следующую улицу
void runExecuteFoldLastPlayerFlopTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
      players[2].uid: 60,
      players[3].uid: 60,
    },
    gameState: GameStatusEnum.flop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[1].uid,
    currentPlayerUid: players[0].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 40,
      players[2].uid: 40,
      players[3].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.turn,
    ),
  );
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[0].uid,
      },
      lapCounter: 0,
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// Тест фолда бигблайнда на префлопе, ожидаем переход на флоп
void runExecuteFoldLastPlayerPreFlopTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
      players[2].uid: 60,
      players[3].uid: 60,
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
      players[1].uid: 40,
      players[2].uid: 40,
      players[3].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.flop,
    ),
  );
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[2].uid,
      },
      lapCounter: 0,
      currentPlayerUid: players[1].uid,
      firstPlayerUid: players[1].uid,
    ),
  );
}

/// Тест фолда всех игроков, кроме 1, ожидаем увидеть его победителем и попасть в Breakdown
void runExecuteFoldAllPlayersPreFlopTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 80,
      players[2].uid: 60,
      players[3].uid: 100,
    },
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[3].uid,
    currentPlayerUid: players[3].uid,
    bets: {
      players[0].uid: 0,
      players[1].uid: 20,
      players[2].uid: 40,
      players[3].uid: 0,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.executeFold();
  await gameStateMachine.executeFold();
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
    ),
  );
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      foldedPlayers: {
        players[3].uid,
        players[0].uid,
        players[1].uid,
      },
      currentPlayerUid: players[1].uid,
    ),
  );
}

/// Тест фолда игрока при оставшемся 1 игроком с фишками, завершаем игру
void runExecuteFoldPlayerWithInactiveTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
    gameState: GameStatusEnum.flop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    firstPlayerUid: players[3].uid,
    currentPlayerUid: players[0].uid,
    bets: {
      players[0].uid: 0,
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
  await gameStateMachine.executeFold();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
    ),
  );
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[0].uid,
      },
    ),
  );
}
