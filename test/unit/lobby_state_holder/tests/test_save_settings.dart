import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/models/game_settings_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void runSaveSettingsNoEditingTest(
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

  final newSettings = GameSettingsModelResult(
    startingStack: null,
    smallBlind: null,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.saveSettings(newSettings);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState, lobbyState);
}

void runSaveSettingsSameBankTest(
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

  final newSettings = GameSettingsModelResult(
    startingStack: defaultLobbyBank,
    smallBlind: null,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.saveSettings(newSettings);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(newLobbyState, lobbyState);
}

void runSaveSettingsNewBankTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newSettings = GameSettingsModelResult(
    startingStack: 333,
    smallBlind: null,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.saveSettings(newSettings);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(
    newLobbyState,
    lobbyState.copyWith(
      defaultBank: 333,
      banks: {
        players[0].uid: 333,
        players[1].uid: 333,
      },
    ),
  );
}

void runSaveSettingsNewSmallBlindTest(
  ProviderContainer container,
  AppRepository repository,
) async {
  // Arrange
  final players = createPlayers(2);
  final lobbyState = createLobbyState(
    players,
    smallBlindValue: 20,
    defaultBank: defaultLobbyBank,
  );

  when(repository.getLobbyState()).thenAnswer((_) async => lobbyState);

  final lobbyStateHolder = container.read(lobbyStateHolderProvider.notifier);

  final newSettings = GameSettingsModelResult(
    startingStack: null,
    smallBlind: 333,
  );

  await lobbyStateHolder.future;
  await lobbyStateHolder.saveSettings(newSettings);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(
    newLobbyState,
    lobbyState.copyWith(
      smallBlindValue: 333,
    ),
  );
}
