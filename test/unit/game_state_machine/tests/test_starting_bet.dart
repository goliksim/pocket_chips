import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_effect.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// [StartingBettingTest] Сheck for pop-up notification if there are not enough players (other players may be inactive/zero).
/// The lobby does not change in any way, autofolding of players without chips is applied
void runStartingBettingWithNoPlayersTest(
  ProviderContainer container,
  AppRepository repository,
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

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  // Lobby check
  expect(gameState.lobbyState, lobbyState);
  // Game state check
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[1].uid,
        players[2].uid,
      },
    ),
  );
  // Effects check
  expect(
    gameState.effects,
    [
      GameStateEffect.error(type: GameStateErrorType.fewPlayers),
    ],
  );
}

/// [StartingBettingTest] common placement of Small and Big blinds
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

/// [StartingBettingTest] placement of Small and Big blinds
/// One of players has no chips
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

/// [StartingBettingTest] placement of Small and Big blinds
/// One of players has no chips (Second)
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

/// [StartingBettingTest] placement of Small and Big blinds
/// Two of players has no chips
/// The Big Blind Player will be on second lap
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

/// [StartingBettingTest] placement of Small and Big blinds
/// Two of players has no chips
/// The Big Blind Player is on first lap
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
