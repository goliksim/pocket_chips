import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../../test_utils.dart';
import '../lobby_state_holder_test.mocks.dart';

void runUpdatePlayerTest(
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

  final newPlayer = players.first.copyWith(
    name: 'Test name',
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.updatePlayer(
    player: newPlayer,
    makeDealer: true,
    bank: 333,
  );

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(newPlayer.uid), true);
  expect(newLobbyState.banks[newPlayer.uid], 333);
  expect(newLobbyState.players.length, 3);
  expect(newLobbyState.players.first, newPlayer);
  expect(newLobbyState.players.first.name, 'Test name');
  expect(newLobbyState.dealerId, newPlayer.uid);
}

void runUpdatePlayerToExistTest(
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

  final newPlayer = PlayerModel(
    uid: players[1].uid,
    name: players.first.name,
    assetUrl: players.first.assetUrl,
  );

  await lobbyStateHolder.future;
  void updatePlayer() => lobbyStateHolder.updatePlayer(
        player: newPlayer,
        makeDealer: true,
        bank: 333,
      );

  expect(
    () => updatePlayer(),
    throwsA(isA<Exception>()),
  );
}

void runUpdatePlayerToExistNameTest(
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

  final newAssetName = AssetsProvider.playerAssetByIndex(2);
  final newPlayer = PlayerModel(
      uid: players[1].uid, name: players.first.name, assetUrl: newAssetName);

  await lobbyStateHolder.future;
  await lobbyStateHolder.updatePlayer(
    player: newPlayer,
    makeDealer: true,
    bank: 333,
  );

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(newPlayer.uid), true);
  expect(newLobbyState.banks[newPlayer.uid], 333);
  expect(newLobbyState.players.length, 3);
  expect(newLobbyState.players[1], newPlayer);
  expect(newLobbyState.players[1].assetUrl, newAssetName);
  expect(newLobbyState.dealerId, newPlayer.uid);
}

void runUpdatePlayerDisableDealerTest(
  ProviderContainer container,
  AppRepository repository,
  MockToastManager toastManager,
) async {
  // Arrange
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
    dealerId: players[2].uid,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);
  var toastManagerPushed = false;
  when(toastManager.showToast(any)).thenAnswer((_) {
    toastManagerPushed = true;
  });

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newPlayer = players[2];

  await lobbyStateHolder.future;
  await lobbyStateHolder.updatePlayer(
    player: newPlayer,
    makeDealer: false,
  );

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(newPlayer.uid), true);
  expect(newLobbyState.banks[newPlayer.uid], defaultLobbyBank);
  expect(newLobbyState.players.length, 3);
  expect(newLobbyState.players[2], newPlayer);
  expect(newLobbyState.dealerId, players.first.uid);

  expect(toastManagerPushed, true);
}
