import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// [HandUpTest] betting start
/// In this case, the dealer makes a small blind and goes first on Pre-flop.
/// The Big blind Player goes second
void runHandUpStaringBetTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
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

  final firstPlayer = players.first;
  expect(
    gameState.sessionState,
    GameSessionState(
      bets: {firstPlayer.uid: 20, players[1].uid: 40},
      foldedPlayers: {},
      lapCounter: 0,
      currentPlayerUid: firstPlayer.uid,
      firstPlayerUid: firstPlayer.uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {firstPlayer.uid: 80, players[1].uid: 60},
    ),
  );
}

/// Тест старта ставок при хенд-апе (все игроки вынуждены идти в олл-ин)
/// В таком случае оба игрока играют на все свои деньги, игра сразу переходит к вскрытию карт.
void runHandUpStaringBetAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {players[0].uid: 20, players[1].uid: 20},
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  final firstPlayer = players.first;
  expect(
    gameState.sessionState,
    GameSessionState(
      bets: {firstPlayer.uid: 20, players[1].uid: 20},
      foldedPlayers: {},
      lapCounter: 0,
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
      banks: {firstPlayer.uid: 0, players[1].uid: 0},
    ),
  );
}

/// [HandUpTest] betting start (the Dealer needs to go AllIn)
/// In this case, only the dealer's bank plays, and the game immediately go to Showdown.
void runHandUpStaringBetFirstAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {players[0].uid: 20, players[1].uid: 100},
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  final firstPlayer = players.first;
  expect(
    gameState.sessionState,
    GameSessionState(
      bets: {firstPlayer.uid: 20, players[1].uid: 40},
      foldedPlayers: {},
      lapCounter: 0,
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
      banks: {firstPlayer.uid: 0, players[1].uid: 60},
    ),
  );
}

/// [HandUpTest] betting start (the second Player needs to go AllIn)
/// In this case, only the second player's bank plays, and the game immediately go to Showdown.
void runHandUpStaringBetSecondAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {players[0].uid: 100, players[1].uid: 20},
  );
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;
  await gameStateMachine.startBetting();

  final gameState = gameStateMachine.state.requireValue;

  final firstPlayer = players.first;
  expect(
    gameState.sessionState,
    GameSessionState(
      bets: {firstPlayer.uid: 20, players[1].uid: 20},
      foldedPlayers: {},
      lapCounter: 0,
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
      banks: {firstPlayer.uid: 80, players[1].uid: 0},
    ),
  );
}

/// [HandUpTest] betting start с (Dealer is inactive)
/// In this case, the First player is the Small Blind, the Second is the Big Blind
/// The Small Blind goes first.
/// Here testing the skip of zero(empty) players
void runHandUpStartingBetNoChipsTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 0,
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
      bets: {
        players[1].uid: 20,
        players[3].uid: 40,
      },
      foldedPlayers: {
        players[0].uid,
        players[2].uid,
      },
      currentPlayerUid: players[1].uid,
      firstPlayerUid: players[1].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 0,
        players[1].uid: 80,
        players[2].uid: 0,
        players[3].uid: 60
      },
    ),
  );
}

/// [HandUpTest] betting start (Dealer is inactive, big blind on second lap)
/// There are zero player in the middle
/// Here testing the skip of zero(empty) players
void runHandUpStartingBetNoChips2Test(
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
    dealerId: players[2].uid,
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
      bets: {players[0].uid: 40, players[3].uid: 20},
      foldedPlayers: {
        players[1].uid,
        players[2].uid,
      },
      currentPlayerUid: players[3].uid,
      firstPlayerUid: players[3].uid,
    ),
  );

  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.preFlop,
      banks: {
        players[0].uid: 60,
        players[1].uid: 0,
        players[2].uid: 0,
        players[3].uid: 80
      },
    ),
  );
}

/// [HandUpTest] betting start (Dealer is inactive and Small Blind AllIn)
/// In this case, the First Player is the Small blind and goes AllIn, the Second is Big Blind
/// Expect transition to Showdown
void runHandUpStartingBetHasNoChipsWithAllInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 0,
      players[1].uid: 20,
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

  final newGameState = gameStateMachine.state.requireValue;

  expect(
    newGameState.sessionState,
    gameSessionState.copyWith(
      bets: {players[1].uid: 20, players[3].uid: 40},
      foldedPlayers: {
        players[0].uid,
        players[2].uid,
      },
    ),
  );

  expect(
    newGameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
      banks: {
        players[0].uid: 0,
        players[1].uid: 0,
        players[2].uid: 0,
        players[3].uid: 60
      },
    ),
  );
}
