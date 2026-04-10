import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_progression_state.dart';

part 'game_session_state.freezed.dart';

@freezed
abstract class GameSessionState with _$GameSessionState {
  const factory GameSessionState({
    required Map<String, int> bets,
    @Default(<String, int>{}) Map<String, int> anteBets,
    required Set<String> foldedPlayers,
    required int lapCounter,
    @Default(GameProgressionState()) GameProgressionState progressionState,
    String? currentPlayerUid,
    String? firstPlayerUid,
  }) = _GameSessionState;

  factory GameSessionState.initial() => GameSessionState(
        bets: {},
        anteBets: {},
        foldedPlayers: {},
        lapCounter: 0,
      );
}
