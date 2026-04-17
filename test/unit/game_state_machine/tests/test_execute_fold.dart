import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_effect.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void expectWinnerSelectionEffect(
  List<GameStateEffect> effects, {
  required Set<String> possibleWinnersUid,
  required bool isSideSpot,
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
    },
  );
}

/// [FoldTest] regular test
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

/// [FoldTest] by Big Blind Player on Pre-flop
/// Expect transition to Flop
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

/// [FoldTest] by all players except one
/// Expect winner effect and Breakdown state
void runExecuteFoldAllPlayersPreFlopTest(
  ProviderContainer container,
  AppRepository repository,
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

  // Effects check
  expect(
    gameState.effects,
    [GameStateEffect.hasWinner(winnerUid: players[2].uid)],
  );
  // Lobby check
  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.gameBreak,
      banks: {
        players[0].uid: 100,
        players[1].uid: 80,
        players[2].uid: 120,
        players[3].uid: 100,
      },
      dealerId: players[1].uid,
    ),
  );
  // Game state check
  expect(gameState.sessionState, GameSessionState.initial());
}

/// [FoldTest] one player lasts after fold, finish the game
/// Expect winner selection Effect
void runExecuteFoldPlayerWithInactiveTest(
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

  // Lobby check
  expect(
    gameState.lobbyState,
    lobbyState.copyWith(
      gameState: GameStatusEnum.showdown,
    ),
  );
  // Game state check
  expect(
    gameState.sessionState,
    gameSessionState.copyWith(
      foldedPlayers: {
        players[0].uid,
      },
    ),
  );
  // Effects check
  expectWinnerSelectionEffect(
    gameState.effects,
    possibleWinnersUid: {players[1].uid, players[2].uid, players[3].uid},
    isSideSpot: false,
  );
}
