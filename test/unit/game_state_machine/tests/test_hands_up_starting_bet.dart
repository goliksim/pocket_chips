import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// Тест старта ставок при хенд-апе.
/// В таком случае дилер делает смол-блайнд, и ходит первым на префлопе.
/// Второй игрок - бигблайнд
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

/// Тест старта ставок при хенд-апе (дилер вынуждены идти в олл-ин)
/// В таком случае играет только банк дилера, игра сразу переходит к вскрытию карт.
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

/// Тест старта ставок при хенд-апе (второй игрок вынуждены идти в олл-ин)
/// В таком случае играет только банк второго игрока, игра сразу переходит к вскрытию карт.
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

/// Тест старта ставок при хенд-апе (дилер не активный)
/// В таком случае первый игрок - смолблайнд, второй - биг блайнд, играет первым смол блайнд
/// Тут тестим скип 0левых игроков
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

/// Тест старта ставок при хенд-апе (дилер - первый игрок)
/// В таком случае первый игрок - смолблайнд, второй - биг блайнд, играет первым смол блайнд
/// Тут тестим скип 0левых игроков
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

/// Тест старта ставок при хенд-апе (дилер не активный)
/// В таком случае первый игрок - смолблайнд идет в олин, второй - биг блайнд, но только он играет
/// Тут тестим скип 0левых игроков
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
