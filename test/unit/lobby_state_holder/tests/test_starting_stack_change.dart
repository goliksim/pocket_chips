import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../test_utils.dart';

void runStartingStackChangeTest(
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

  final newBank = 333;

  await lobbyStateHolder.future;
  await lobbyStateHolder.updateDefaultBank(newBank);

  final newLobbyState = lobbyStateHolder.state.requireValue;

  expect(
    newLobbyState.defaultBank,
    newBank,
  );

  final newBanksSet = newLobbyState.banks.values.toSet();

  expect(newBanksSet.length, 1);
  expect(newBanksSet.first, 333);
}
