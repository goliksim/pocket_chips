import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../../test_utils.dart';

void runAddPlayerTest(
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

  final newPlayer = PlayerModel(
    uid: 'p4',
    name: 'Player 4',
    assetUrl: AssetsProvider.emptyPlayerAsset,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.addPlayer(
    player: newPlayer,
    makeDealer: true,
  );

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey(newPlayer.uid), true);
  expect(newLobbyState.banks[newPlayer.uid], defaultLobbyBank);
  expect(newLobbyState.players.length, 4);
  expect(newLobbyState.players.last, newPlayer);
  expect(newLobbyState.dealerId, newPlayer.uid);
}

void runAddPlayerCustomBankTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: 100,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newPlayer = PlayerModel(
    uid: 'p4',
    name: 'Player 4',
    assetUrl: AssetsProvider.emptyPlayerAsset,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.addPlayer(
    player: newPlayer,
    makeDealer: true,
    bank: 333,
  );

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState.banks.containsKey('p4'), true);
  expect(newLobbyState.banks['p4'], 333);
  expect(newLobbyState.players.length, 4);
  expect(newLobbyState.players.last, newPlayer);
  expect(newLobbyState.dealerId, newPlayer.uid);
}

void runAddExistPlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: 100,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newPlayer = PlayerModel(
    uid: 'new_uid',
    name: players.first.name,
    assetUrl: players.first.assetUrl,
  );

  await lobbyStateHolder.future;
  void addPlayer() => lobbyStateHolder.addPlayer(
        player: newPlayer,
        makeDealer: true,
        bank: 333,
      );

  expect(
    () => addPlayer(),
    throwsA(isA<Exception>()),
  );
}

void runAddExistNamePlayerTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(3);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: 100,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newPlayer = PlayerModel(
    uid: 'new_uid',
    name: players.first.name,
    assetUrl: AssetsProvider.playerAssetByIndex(2),
  );

  await lobbyStateHolder.future;
  void addPlayer() => lobbyStateHolder.addPlayer(
        player: newPlayer,
        makeDealer: true,
        bank: 333,
      );

  expect(
    () => addPlayer(),
    throwsA(isA<Exception>()),
  );
}

void runAddPlayerWhileMaxTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  final players = createPlayers(maxPlayerCount);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: 100,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newPlayer = PlayerModel(
    uid: 'p1',
    name: 'Player 1',
    assetUrl: AssetsProvider.emptyPlayerAsset,
  );

  await lobbyStateHolder.future;
  void addPlayer() => lobbyStateHolder.addPlayer(
        player: newPlayer,
        makeDealer: false,
      );

  expect(
    () => addPlayer(),
    throwsA(isA<Exception>()),
  );
}
