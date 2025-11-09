import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/game_logic_service.dart';

import '../../test_utils.dart';

/// Тестируем  колл для смол блайнда на префлопе
void runCallValueCalculationSmallBlindTest(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 10);
  expect(isAllIn, false);
}

/// Тестируем  колл для биг блайнда на префлопе
void runCallValueCalculationBigBlindTest(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 0);
  expect(isAllIn, false);
}

/// Тестируем  колл для первого игрока на префлопе
void runCallValueCalculationBigBlind2Test(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 20);
  expect(isAllIn, false);
}

/// Тестируем колл рейза для игрока на префлопе
void runCallRaisePreflopValueCalculationTest(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 100);
  expect(isAllIn, false);
}

/// Тестируем  колл рейза для игрока на флопе
void runReCallFlopValueCalculationTest(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 100);
  expect(isAllIn, false);
}

/// Тестируем колл для игрока на флопе
void runCallValueCalculationTurnTest(
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 0);
  expect(isAllIn, false);
}

/// Тестируем случай олина после рейза
void runCallRaiseValueCalculationAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 10,
    gameState: GameStatusEnum.flop,
    defaultBank: 10,
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

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 20);
  expect(isAllIn, true);
}

/// Тест кола игрока после олина бигблайнда
/// Ожидаем велечину кола размеров с бигблайнд
void runCallValueCalculationBBAllInTest(
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
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[2].uid,
    bets: {
      players[0].uid: 100,
      players[1].uid: 50,
      players[2].uid: 0,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;
  final currentPlayerUid = currentState.sessionState.currentPlayerUid;

  expect(currentPlayerUid != null, true);

  final (callValue, isAllIn) =
      currentState.calculateCallValue(currentPlayerUid!);

  expect(callValue, 200);
  expect(isAllIn, false);
}
