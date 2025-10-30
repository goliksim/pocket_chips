import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/model_holders/config_model_holder.dart';
import '../domain/model_holders/lobby_state_holder.dart';
import '../domain/model_holders/saved_players_model_holder.dart';
import 'domain_managers.dart';
import 'repositories.dart';

final configModelHolderProvider = Provider.autoDispose(
  (ref) => ConfigModelHolder(
    repository: ref.watch(appRepositoryProvider),
  ),
);

final lobbyStateHolderProvider = Provider.autoDispose<LobbyStateHolder>(
  (ref) => LobbyStateHolder(
    repository: ref.watch(appRepositoryProvider),
    strings: ref.watch(stringsProvider),
  ),
);

final savedPlayersModelHolderProvider =
    Provider.autoDispose<SavedPlayersModelHolder>(
  (ref) => SavedPlayersModelHolder(
    repository: ref.watch(appRepositoryProvider),
  ),
);

final gameStateMachineProvider = Provider(
  (ref) => GameStateMachine(
    navigationManager: ref.watch(navigationManagerProvider),
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    toastManager: ref.watch(toastManagerProvider),
    appRepository: ref.watch(appRepositoryProvider),
    strings: ref.watch(stringsProvider),
  ),
);
