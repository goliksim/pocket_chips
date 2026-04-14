import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_progression_state.freezed.dart';

@freezed
abstract class GameProgressionState with _$GameProgressionState {
  const factory GameProgressionState({
    @Default(0) int currentLevelIndex,
    int? handsFromLevelStart,
    int? levelTimerStartMsUtc,
  }) = _GameProgressionState;
}

extension GameProgressionStateX on GameProgressionState {
  int? minutesUntilNextLevelAt(DateTime nowUtc, {required int? intervalMin}) =>
      levelTimerStartMsUtc != null && intervalMin != null
          ? ((levelTimerStartMsUtc! +
                      intervalMin * 60000 -
                      nowUtc.millisecondsSinceEpoch) /
                  60000)
              .ceil()
          : null;

  int? handsUntilNextLevel({required int? intervalMin}) =>
      handsFromLevelStart != null && intervalMin != null
          ? (intervalMin - handsFromLevelStart!)
          : null;
}
