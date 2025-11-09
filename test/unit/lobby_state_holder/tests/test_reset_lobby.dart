import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void runResetLobbyChangeTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    banks: {
      players[0].uid: 10,
      players[1].uid: 20,
    },
    defaultBank: defaultLobbyBank,
  ).copyWith(
    gameState: GameStatusEnum.turn,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.resetLobby();

  final newLobbyState = lobbyStateHolder.state.requireValue;

  final newBanksSet = newLobbyState.banks.values.toSet();
  expect(newLobbyState.gameState, GameStatusEnum.notStarted);
  expect(newBanksSet.length, 1);
  expect(newBanksSet.first, defaultLobbyBank);
}
