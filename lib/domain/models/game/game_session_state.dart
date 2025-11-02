import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_state.freezed.dart';

@freezed
abstract class GameSessionState with _$GameSessionState {
  const factory GameSessionState({
    required Map<String, int> bets,
    required Set<String> foldedOrInactive,
    required int lapCounter,
    String? currentPlayerUid,
    String? firstPlayerUid,
  }) = _GameSessionState;
}
