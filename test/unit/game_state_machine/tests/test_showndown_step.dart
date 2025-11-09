import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';

import '../../test_utils.dart';
import '../game_state_machine_test.mocks.dart';

/// Тестируем распределение фишек и показ модального окна
void runShowdownWinFromFoldedTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 100,
      players[1].uid: 80,
      players[2].uid: 60,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {
      players[0].uid,
      players[1].uid,
    },
    currentPlayerUid: players[1].uid,
    firstPlayerUid: players[0].uid,
    bets: {
      players[1].uid: 20,
      players[2].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  PlayerModel? winner;
  when(navigationManager.showWinner(any)).thenAnswer((inc) async {
    winner = inc.positionalArguments[0];
  });

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(winner, players[2]);
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 80,
        players[2].uid: 120,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша при 1 победителе
void runShowdownEqualBidsOneWinnerTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
      players[2].uid: 60,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 40,
      players[2].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  Set<String>? possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer((inc) async {
    possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
        .possibleWinners
        .map((p) => (p.uid))
        .toSet();
    return {players[0].uid};
  });

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    players.map((p) => p.uid).toSet(),
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 180,
        players[1].uid: 60,
        players[2].uid: 60,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша при 2ух победителях
void runShowdownEqualBidsTwoWinnerTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
      players[2].uid: 60,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 40,
      players[2].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  Set<String>? possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();
      return {
        players[0].uid,
        players[1].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    players.map((p) => p.uid).toSet(),
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 120,
        players[1].uid: 120,
        players[2].uid: 60,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша при всех победителях
void runShowdownEqualBidsAllWinnersTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 60,
      players[1].uid: 60,
      players[2].uid: 60,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 40,
      players[2].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return Set<String>.of(possibleWinners);
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    players.map((p) => p.uid).toSet(),
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 100,
        players[2].uid: 100,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша в случае наличия основных и сайд спотов
/// Тут побеждает игрок олина
/// Скипаем в конце дилера до активного
void runShowdownTwoAllPreflopInTest(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[3].uid,
    bets: {
      players[1].uid: 10,
      players[2].uid: 40,
      players[3].uid: 10,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {
        players[1].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid, players[3].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 30,
        players[2].uid: 90,
        players[3].uid: 0
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша в случае наличия основных и сайд спотов
/// Тут побеждает игрок бигблайнда
void runShowdownTwoAllPreflopIn2Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[3].uid,
    bets: {
      players[1].uid: 10,
      players[2].uid: 40,
      players[3].uid: 10,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {
        players[2].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid, players[3].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      // Скипаем дилера до активного
      dealerId: players[2].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 0,
        players[2].uid: 120,
        players[3].uid: 0
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша в случае наличия основных и сайд спотов
/// Тут побеждает и игрок бигблайнда и олинщик
void runShowdownTwoAllPreflopIn3Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[3].uid,
    bets: {
      players[1].uid: 10,
      players[2].uid: 40,
      players[3].uid: 10,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {
        players[1].uid,
        players[2].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid, players[3].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 15,
        players[2].uid: 105,
        players[3].uid: 0
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем показ модального окна выбора и распределение выйгрыша в случае наличия основных и сайд спотов
/// Тут побеждают все
void runShowdownTwoAllPreflopIn4Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[3].uid,
    bets: {
      players[1].uid: 10,
      players[2].uid: 40,
      players[3].uid: 10,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return Set.of(possibleWinners);
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid, players[3].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 100,
        players[1].uid: 10,
        players[2].uid: 100,
        players[3].uid: 10,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем интересный кейс
/// Игрок 1 поставил 40 и фолданул на флопе
/// Игрок 2 поставил олин 300
/// Игрок 3 рейзнул до 400
/// Игрок 4 фолданул со ставкой 300
/// Выйграл первый игрок
void runShowdownDistribution1Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 460,
      players[1].uid: 0,
      players[2].uid: 100,
      players[3].uid: 200,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {players[0].uid, players[3].uid},
    currentPlayerUid: players[3].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 300,
      players[2].uid: 400,
      players[3].uid: 300,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {
        players[1].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 460,
        players[1].uid: 940,
        players[2].uid: 200,
        players[3].uid: 200,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем интересный кейс
/// Игрок 1 поставил 40 и фолданул на флопе
/// Игрок 2 поставил олин 300
/// Игрок 3 рейзнул до 400
/// Игрок 4 фолданул со ставкой 300
/// Выйграл второй игрок, проверяем скип дилера
void runShowdownDistribution2Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 460,
      players[1].uid: 0,
      players[2].uid: 100,
      players[3].uid: 200,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {players[0].uid, players[3].uid},
    currentPlayerUid: players[3].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40,
      players[1].uid: 300,
      players[2].uid: 400,
      players[3].uid: 300,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> possibleWinners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      possibleWinners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {
        players[2].uid,
      };
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    possibleWinners,
    {players[1].uid, players[2].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      // Скипаем первого игрока, не может быть дилером
      dealerId: players[2].uid,
      banks: {
        players[0].uid: 460,
        players[1].uid: 0,
        players[2].uid: 1140,
        players[3].uid: 200,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем интересный кейс
/// Игрок 1 поставил 40 и фолданул на флопе
/// Игрок 2 поставил олин 300 и фолданул
/// Игрок 3 рейзнул до 440
/// Игрок 4 кол
/// Игрок 5 кол
/// Основной банк выйграл олинщик
/// Cайд пот выйрал первый
void runShowdownDistribution3Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(5);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 60,
      players[1].uid: 460,
      players[2].uid: 0,
      players[3].uid: 60,
      players[4].uid: 60,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {players[1].uid},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 440,
      players[1].uid: 40,
      players[2].uid: 300,
      players[3].uid: 440,
      players[4].uid: 440,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> winners1;
  late final Set<String> winners2;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      var winners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      if (winners.length == 4) {
        winners1 = winners;
      } else {
        winners2 = winners;
      }

      return winners.length == 4 ? {players[2].uid} : {players[0].uid};
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    winners1,
    {players[0].uid, players[2].uid, players[3].uid, players[4].uid},
  );
  expect(
    winners2,
    {players[0].uid, players[3].uid, players[4].uid},
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[1].uid,
      banks: {
        players[0].uid: 480,
        players[1].uid: 460,
        players[2].uid: 1240,
        players[3].uid: 60,
        players[4].uid: 60,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// Тестируем распределение фишек и показ модального окна
/// Все игроки олин, выйгрывает последний, он остается дилером
void runShowdownDistribution4Test(
  ProviderContainer container,
  AppRepository repository,
  MockNavigationManager navigationManager,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 0,
      players[1].uid: 0,
      players[2].uid: 0,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 500,
      players[1].uid: 500,
      players[2].uid: 500,
      players[3].uid: 500,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  late final Set<String> winners;
  when(navigationManager.showWinnerChooseDialog(any)).thenAnswer(
    (inc) async {
      winners = (inc.positionalArguments[0] as WinnerChoiceArgs)
          .possibleWinners
          .map((p) => (p.uid))
          .toSet();

      return {players.last.uid};
    },
  );

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  final currentState = await gameStateMachine.future;

  await gameStateMachine.showWinnersAndEndLap(model: currentState);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    winners,
    players.map((e) => e.uid).toSet(),
  );
  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      dealerId: players[3].uid,
      banks: {
        players[0].uid: 0,
        players[1].uid: 0,
        players[2].uid: 0,
        players[3].uid: 2000,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}
