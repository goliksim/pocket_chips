import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// Тест ре-рейза на втором круге ставок, если кто-то рейзанул, а мы его ре-рейзнули
/// Идем дальше до выравнивания
void runExecuteReRaiseLastTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    gameState: GameStatusEnum.flop,
    banks: {
      players[0].uid: 420,
      players[1].uid: 420,
      players[2].uid: 420,
      players[3].uid: 460,
    },
  );
  final gameSessionState = GameSessionState(
    lapCounter: 1,
    foldedPlayers: {},
    currentPlayerUid: players[3].uid,
    firstPlayerUid: players[1].uid,
    bets: {
      players[0].uid: 80,
      players[1].uid: 80,
      players[2].uid: 80,
      players[3].uid: 40,
    },
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameStateMachine = container.read(gameStateMachineProvider.notifier);
  await gameStateMachine.future;

  await gameStateMachine.executeRaise(80);

  final finalState = gameStateMachine.state.requireValue;

  expect(
    finalState.lobbyState,
    lobbyState.copyWith(
      banks: {
        players[0].uid: 420,
        players[1].uid: 420,
        players[2].uid: 420,
        players[3].uid: 380,
      },
    ),
  );
  expect(
    finalState.sessionState,
    gameSessionState.copyWith(
      lapCounter: 1,
      bets: {
        players[0].uid: 80,
        players[1].uid: 80,
        players[2].uid: 80,
        players[3].uid: 120,
      },
      foldedPlayers: {},
      currentPlayerUid: players[0].uid,
    ),
  );
}
