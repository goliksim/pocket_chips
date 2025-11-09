import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/game_logic_service.dart';

import '../../test_utils.dart';

/// Тестируем минимальный рейз для смол блайнда на префлопе
void runRaiseValueCalculationSmallBlindTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players.first.uid,
    bets: {
      players[0].uid: 10,
      players[1].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 30);
  expect(isAllIn, false);
}

/// Тестируем минимальный рейз для биг блайнда на префлопе
void runRaiseValueCalculationBigBlindTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 20,
      players[1].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 20);
  expect(isAllIn, false);
}

/// Тестируем минимальный рейз для первого игрока на префлопе
void runRaiseValueCalculationBigBlind2Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[2].uid,
    bets: {
      players[0].uid: 10,
      players[1].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 40);
  expect(isAllIn, false);
}

/// Тестируем минимальный ре-рейз для игрока на префлопе
void runReRaisePreflopValueCalculationTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.preFlop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[3].uid,
    bets: {
      players[0].uid: 10,
      players[1].uid: 20,
      players[2].uid: 100,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 180);
  expect(isAllIn, false);
}

/// Тестируем минимальный ре-рейз для игрока на флопе
void runReRaiseFlopValueCalculationTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.flop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 120,
      players[1].uid: 20,
      players[2].uid: 20,
      players[3].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 200);
  expect(isAllIn, false);
}

/// Тестируем минимальную ставку для игрока на флопе
void runBetValueCalculationTurnTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.flop,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    bets: {
      players[0].uid: 400,
      players[1].uid: 400,
      players[2].uid: 400,
      players[3].uid: 400,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 20);
  expect(isAllIn, false);
}

/// Тестируем случай олина для ре-рейза
void runReRaiseValueCalculationAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.flop,
    defaultBank: 30,
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 20,
      players[2].uid: 20,
      players[3].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (raiseValue, isAllIn) =
      currentState.calculateRaiseValue(currentPlayerUid!);

  expect(raiseValue, 40);
  expect(isAllIn, true);
}
