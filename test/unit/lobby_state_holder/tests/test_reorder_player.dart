import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void runReorderSamePlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(0, 0);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.players, players);
}

void runReorderSinglePlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(1);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(0, 0);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.players, players);
}

void runReorderTwoPlayersTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(0, 2);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.players, players.reversed.toList());

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(1, 0);

  final newLobbyState2 = lobbyStateHolder.state.requireValue;

  expect(newLobbyState2.players, players);
}

void runReorderToFirstTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(3, 0);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(
    newLobbyState.players,
    [players[3], players[0], players[1], players[2]],
  );
}

void runReorderToLastTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(4);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  await lobbyStateHolder.future;
  await lobbyStateHolder.reorderPlayer(0, 4);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(
    newLobbyState.players,
    [players[1], players[2], players[3], players[0]],
  );
}
