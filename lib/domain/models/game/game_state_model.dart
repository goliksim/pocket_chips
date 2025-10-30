import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../lobby/lobby_state_model.dart';
import '../player/player_model.dart';
import 'game_session_state.dart';

part 'game_state_model.freezed.dart';

@freezed
abstract class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required LobbyStateModel lobbyState,
    required GameSessionState sessionState,
  }) = _GameStateModel;
}

extension GameStateModelExt on GameStateModel {
  Iterable<PlayerModel> get activePlayers => lobbyState.players
      .whereNot((e) => sessionState.foldedOrInactive.contains(e.uid));

  bool get canStartOrContinueGame => activePlayers.length >= 2;
}
