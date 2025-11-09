import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

/// Тестируем корректную инициализацию нотифаера
void runInitialization(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(players);
  final gameSessionState = GameSessionState.initial();

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  when(repository.getGameSessionState())
      .thenAnswer((_) async => gameSessionState);

  final gameState = await container.read(gameStateMachineProvider.future);

  expect(gameState.lobbyState, lobbyState);
  expect(gameState.sessionState, gameSessionState);
}

/// Тестируем автоматический фолд игроков без фишек
void runInitializationAndAutoFold(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
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

  final gameState = await container.read(gameStateMachineProvider.future);

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
