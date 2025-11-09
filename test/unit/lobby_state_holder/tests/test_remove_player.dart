import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void runRemovePlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final playerToRemoveId = players[1].uid;

  await lobbyStateHolder.future;
  await lobbyStateHolder.removePlayer(playerToRemoveId);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(playerToRemoveId), false);
  expect(newLobbyState.players.length, 2);
  expect(newLobbyState.dealerId, players.first.uid);
}

void runRemoveUnexistedPlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final playerToRemoveId = 'new_id';

  await lobbyStateHolder.future;
  void removePlayer() => lobbyStateHolder.removePlayer(playerToRemoveId);

  expect(
    () => removePlayer(),
    throwsA(isA<Exception>()),
  );
}

void runRemoveDealerPlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
    dealerId: players[1].uid,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final playerToRemoveId = players[1].uid;

  await lobbyStateHolder.future;
  await lobbyStateHolder.removePlayer(playerToRemoveId);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(playerToRemoveId), false);
  expect(newLobbyState.players.length, 2);
  expect(newLobbyState.dealerId, players[2].uid);
}

void runRemoveDealerFirstPlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
    dealerId: players.first.uid,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final playerToRemoveId = players.first.uid;

  await lobbyStateHolder.future;
  await lobbyStateHolder.removePlayer(playerToRemoveId);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(playerToRemoveId), false);
  expect(newLobbyState.players.length, 2);
  expect(newLobbyState.dealerId, players[1].uid);
}

void runRemoveLastPlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(1);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
    dealerId: players.first.uid,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final playerToRemoveId = players.first.uid;

  await lobbyStateHolder.future;
  await lobbyStateHolder.removePlayer(playerToRemoveId);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(playerToRemoveId), false);
  expect(newLobbyState.players.length, 0);
  expect(newLobbyState.dealerId, null);
}
