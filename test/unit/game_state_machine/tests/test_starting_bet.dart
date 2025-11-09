import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';
import '../game_state_machine_test.mocks.dart';

/// Тестируем показ модального окна при начале ставок с 1 игроком
/// Лобби никак не меняется, применяется автофолд игроков без фишек
void runStartingBettingWithNoPlayersTest(
  ProviderContainer container,
  AppRepository repository,
  MockToastManager toastManager,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 0,
    },
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  var toastManagerPushed = false;
  when(toastManager.showToast(any)).thenAnswer((_) {
    toastManagerPushed = true;
  });

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(toastManagerPushed, true);
  expect(gameState.lobbyState, lobbyState);
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[1].uid,
        players[2].uid,
      },
    ),
  );
}

/// Тестируем обычное проставление смол и биг блайнда
void runStartingBettingTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: 100,
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    GameSessionState(
      bets: {players[1].uid: 20, players[2].uid: 40},
      foldedPlayers: {},
      lapCounter: 0,
      currentPlayerUid: players.first.uid,
      firstPlayerUid: players.first.uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {players[0].uid: 100, players[1].uid: 80, players[2].uid: 60},
    ),
  );
}

/// Тестируем обычное проставление смол и биг блайнда
/// Тут тестируем кейс, что у первого игрока нет фишек
void runStartingBetFirstNoChipsTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 100,
      players[3].uid: 100
    },
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {players[2].uid: 20, players[3].uid: 40},
      foldedPlayers: {
        players[1].uid,
      },
      currentPlayerUid: players[0].uid,
      firstPlayerUid: players[0].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 100,
        players[1].uid: 0,
        players[2].uid: 80,
        players[3].uid: 60
      },
    ),
  );
}

/// Тестируем обычное проставление смол и биг блайнда
/// Тут тестируем кейс, что у второго игрока нет фишек
void runStartingBetSecondNoChipsTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 100,
      players[2].uid: 0,
      players[3].uid: 100
    },
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {players[1].uid: 20, players[3].uid: 40},
      foldedPlayers: {
        players[2].uid,
      },
      currentPlayerUid: players[0].uid,
      firstPlayerUid: players[0].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 100,
        players[1].uid: 80,
        players[2].uid: 0,
        players[3].uid: 60
      },
    ),
  );
}

/// Тестируем обычное проставление смол и биг блайнда
/// Тут тестируем кейс, что у первого и второго игроков нет фишек
/// Биг блайнд уже на втором круге
void runStartingBetFirstSecondNoChipsTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 0,
      players[3].uid: 100
    },
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {players[0].uid: 20, players[3].uid: 40},
      foldedPlayers: {
        players[1].uid,
        players[2].uid,
      },
      currentPlayerUid: players[0].uid,
      firstPlayerUid: players[0].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 80,
        players[1].uid: 0,
        players[2].uid: 0,
        players[3].uid: 60
      },
    ),
  );
}

/// Тестируем обычное проставление смол и биг блайнда
/// Тут тестируем кейс, что у первого игрока нет фишек
/// Биг блайнд еще на первом круге
void runStartingBetFirstSecondNoChips2Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(5);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 0,
      players[3].uid: 100,
      players[4].uid: 100,
    },
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {players[3].uid: 20, players[4].uid: 40},
      foldedPlayers: {
        players[1].uid,
        players[2].uid,
      },
      currentPlayerUid: players[0].uid,
      firstPlayerUid: players[0].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 100,
        players[1].uid: 0,
        players[2].uid: 0,
        players[3].uid: 80,
        players[4].uid: 60,
      },
    ),
  );
}
