import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/blind_level_model.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_effect.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void expectWinnerSelectionEffect(
  List<GameStateEffect> effects, {
  required Set<String> possibleWinnersUid,
  required bool isSideSpot,
  int? expectedAnteValue,
  int? expectedFoldedValue,
}) {
  expect(effects.length, 1);

  final effect = effects.single;
  expect(effect, isA<GameStateNeedWinnerSelectionEffect>());

  effect.map(
    error: (_) => fail('Expected needWinnerSelection effect'),
    hasWinner: (_) => fail('Expected needWinnerSelection effect'),
    needWinnerSelection: (effect) {
      expect(effect.playerContributions.keys.toSet(), possibleWinnersUid);
      expect(effect.isSideSpot, isSideSpot);
      if (expectedAnteValue != null) {
        expect(effect.anteValue, expectedAnteValue);
      }
      if (expectedFoldedValue != null) {
        expect(effect.foldedValue, expectedFoldedValue);
      }
    },
  );
}

/// [ShowdownTest] Money distribution and winner dialog after all players folds
void runShowdownWinFromFoldedTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.river,
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final finalState = gameStateMachine.state.requireValue;

  // Lobby check
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
  // Game state check
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
  // Effects check
  expect(
    finalState.effects,
    [GameStateEffect.hasWinner(winnerUid: players[2].uid)],
  );
}

/// [ShowdownTest] Money distribution and winner selection dialog
/// Selecting only one winner
void runShowdownEqualBidsOneWinnerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.river,
    banks: {
      players[0].uid: 60, // dealer
      players[1].uid: 60, // sm blind
      players[2].uid: 60, // bb blind
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 40, // dealer
      players[1].uid: 40, // sm blind
      players[2].uid: 40, // bb blind
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCheck();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = players.map((p) => p.uid).toSet();
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[0].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
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

/// [ShowdownTest] Money distribution and winner selection dialog
/// Selecting two winners
void runShowdownEqualBidsTwoWinnerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.river,
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCheck();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = players.map((p) => p.uid).toSet();
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[0].uid, players[1].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
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

/// [ShowdownTest] Money distribution and winner selection dialog
/// Selecting all players as a winners
void runShowdownEqualBidsAllWinnersTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.river,
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCheck();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = players.map((p) => p.uid).toSet();
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: expectedWinners,
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
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

/// [ShowdownTest] Money distribution and winner selection dialog on Pre-flop
/// Selecting AllIn player as a winner
/// Skipping dealer to next active player
void runShowdownTwoAllPreflopInTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 100, // folded
      players[1].uid: 0, // all in 10
      players[2].uid: 60, // bet 40
      players[3].uid: 0, // all in 10
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = {players[1].uid, players[2].uid, players[3].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[1].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {players[3].uid},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// [ShowdownTest] Money distribution and winner selection dialog on Pre-flop
/// Selecting Richest player as a winner
/// Other were in AllIn, but lost
void runShowdownTwoAllPreflopIn2Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = {players[1].uid, players[2].uid, players[3].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[2].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {players[1].uid, players[3].uid},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// [ShowdownTest] Money distribution and winner selection dialog
/// Here we have main and side-spot
/// Selecting AllIn and Big Blind Players as a winners
void runShowdownTwoAllPreflopIn3Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = {players[1].uid, players[2].uid, players[3].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[1].uid, players[2].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      bets: {},
      foldedPlayers: {players[3].uid},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// [ShowdownTest] Money distribution and winner selection dialog
/// Here we have main and side-spot
/// Selecting all players as a winner
void runShowdownTwoAllPreflopIn4Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 100,
      players[1].uid: 0,
      players[2].uid: 60,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = {players[1].uid, players[2].uid, players[3].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: expectedWinners,
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
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

/// [ShowdownTest] Interesting case
/// Player 0 bet 40 and folded on the Flop
/// Player 1 bet all-in 300
/// Everyone call on the turn
/// Player 2 raised to 400 on the River
/// Player 3 folded with a bet of 300.
/// The first player wins
void runShowdownDistribution1Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.turn,
    banks: {
      players[0].uid: 460,
      players[1].uid: 0,
      players[2].uid: 100,
      players[3].uid: 200,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {players[0].uid},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

// Effects check
  final expectedWinners = {players[1].uid, players[2].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[1].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
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

/// [ShowdownTest] Interesting case
/// Player 0 bet 40 and folded on the Flop
/// Player 1 bet all-in 300
/// Everyone call on the turn
/// Player 2 raised to 400 on the River
/// Player 3 folded with a bet of 300.
/// The second player wins, we check the dealer's skip
void runShowdownDistribution2Test(
  ProviderContainer container,
  AppRepository repository,
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
    foldedPlayers: {players[0].uid},
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);

  await gameStateMachine.future;

  await gameStateMachine.executeFold();
  final tempState = gameStateMachine.state.requireValue;

// Effects check
  final expectedWinners = {players[1].uid, players[2].uid};
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[2].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
      foldedPlayers: {players[1].uid},
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// [ShowdownTest] Interesting case
/// Player 1 bet 40 and folded on the Flop
/// Player 2 bet all-in 300
/// Player 3 raised to 440
/// Player 4,0 called
/// The main pot was won by all-in player
/// The first player won the side-spot
void runShowdownDistribution3Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(5);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.river,
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

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeCheck();

  final tempState1 = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners1 = {
    players[0].uid,
    players[2].uid,
    players[3].uid,
    players[4].uid
  };
  expectWinnerSelectionEffect(
    tempState1.effects,
    possibleWinnersUid: expectedWinners1,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[2].uid},
  );
  final tempState2 = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners2 = {players[0].uid, players[3].uid, players[4].uid};
  expectWinnerSelectionEffect(
    tempState2.effects,
    possibleWinnersUid: expectedWinners2,
    isSideSpot: true,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[0].uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
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

/// [ShowdownTest] Money distribution and winner selection dialog
/// All players are AllIn, last one win, he will be dealer
void runShowdownDistribution4Test(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.preFlop,
    banks: {
      players[0].uid: 0,
      players[1].uid: 0,
      players[2].uid: 460,
      players[3].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {},
    currentPlayerUid: players[2].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 500,
      players[1].uid: 500,
      players[2].uid: 40,
      players[3].uid: 500,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeAllIn();

  final tempState = gameStateMachine.state.requireValue;

  // Effects check
  final expectedWinners = players.map((e) => e.uid).toSet();
  expectWinnerSelectionEffect(
    tempState.effects,
    possibleWinnersUid: expectedWinners,
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players.last.uid},
  );
  final finalState = gameStateMachine.state.requireValue;

  expect(finalState.effects, []);
  // Lobby check
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
  // Game state check
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 0,
      bets: {},
      foldedPlayers: {
        players[0].uid,
        players[1].uid,
        players[2].uid,
      },
      currentPlayerUid: null,
      firstPlayerUid: null,
    ),
  );
}

/// [ShowdownTest] folded-only extra bet is skipped as a separate pot
/// and shown as folded dead money in the next selectable pot.
void runShowdownFoldedDeadMoneyEffectTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.showdown,
    banks: {
      for (final player in players) player.uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {players[0].uid},
    currentPlayerUid: players[1].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 10,
      players[1].uid: 20,
      players[2].uid: 20,
      players[3].uid: 20,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  final gameState = gameStateMachine.state.requireValue;

  expectWinnerSelectionEffect(
    gameState.effects,
    possibleWinnersUid: {
      players[1].uid,
      players[2].uid,
      players[3].uid,
    },
    isSideSpot: false,
    expectedFoldedValue: 10,
  );
}

/// [ShowdownTest] traditional ante stays proportional across side pots.
void runShowdownTraditionalAnteDistributionTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    anteType: AnteType.traditional,
    anteValue: 100,
    gameState: GameStatusEnum.showdown,
    banks: {
      players[0].uid: 0,
      players[1].uid: 0,
      players[2].uid: 0,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 0,
    foldedPlayers: {},
    currentPlayerUid: players[0].uid,
    firstPlayerUid: players[0].uid,
    bets: {
      players[0].uid: 0,
      players[1].uid: 1000,
      players[2].uid: 1000,
    },
    anteBets: {
      players[0].uid: 10,
      players[1].uid: 100,
      players[2].uid: 100,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  final initialState = gameStateMachine.state.requireValue;
  expectWinnerSelectionEffect(
    initialState.effects,
    possibleWinnersUid: {
      players[0].uid,
      players[1].uid,
      players[2].uid,
    },
    isSideSpot: false,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[0].uid},
  );

  final sidePotState = gameStateMachine.state.requireValue;
  expectWinnerSelectionEffect(
    sidePotState.effects,
    possibleWinnersUid: {
      players[1].uid,
      players[2].uid,
    },
    isSideSpot: true,
  );

  await gameStateMachine.executeWinnerSelection(
    selectedWinners: {players[1].uid},
  );

  final finalState = gameStateMachine.state.requireValue;

  expect(
    finalState.lobbyState.banks,
    {
      players[0].uid: 30,
      players[1].uid: 2180,
      players[2].uid: 0,
    },
  );
  expect(finalState.effects, []);
}
