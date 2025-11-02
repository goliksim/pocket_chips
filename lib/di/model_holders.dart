import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/model_holders/config_model_holder.dart';
import '../domain/model_holders/game_state_machine.dart';
import '../domain/model_holders/lobby_state_holder.dart';
import '../domain/model_holders/saved_players_model_holder.dart';
import '../domain/models/config_model.dart';
import '../domain/models/game/game_state_model.dart';
import '../domain/models/lobby/lobby_state_model.dart';

final configModelHolderProvider =
    AsyncNotifierProvider<ConfigModelHolder, ConfigModel>(
  ConfigModelHolder.new,
);

final lobbyStateHolderProvider =
    AsyncNotifierProvider<LobbyStateHolder, LobbyStateModel>(
  LobbyStateHolder.new,
);

final savedPlayersModelHolderProvider =
    AsyncNotifierProvider.autoDispose<SavedPlayersModelHolder, SavedPlayers>(
  SavedPlayersModelHolder.new,
);

final gameStateMachineProvider =
    AsyncNotifierProvider<GameStateMachine, GameStateModel>(
  GameStateMachine.new,
);
