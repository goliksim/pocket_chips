import 'package:freezed_annotation/freezed_annotation.dart';

import '../lobby/lobby_state_model.dart';
import 'game_session_state.dart';
import 'game_state_effect.dart';

part 'game_state_model.freezed.dart';

@freezed
abstract class GameStateModel with _$GameStateModel {
  const factory GameStateModel({
    required LobbyStateModel lobbyState,
    required GameSessionState sessionState,
    @Default(<GameStateEffect>[]) List<GameStateEffect> effects,
  }) = _GameStateModel;
}
