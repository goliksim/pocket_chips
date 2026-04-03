import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_progression_state.freezed.dart';

@freezed
abstract class GameProgressionState with _$GameProgressionState {
  const factory GameProgressionState({
    @Default(0) int currentLevelIndex,
    int? handsUntilNextLevel,
    int? nextLevelAtEpochMsUtc,
  }) = _GameProgressionState;
}

extension GameProgressionStateX on GameProgressionState {
  int? minutesUntilNextLevelAt(DateTime nowUtc) => nextLevelAtEpochMsUtc != null
      ? ((nextLevelAtEpochMsUtc! - nowUtc.millisecondsSinceEpoch) / 60000)
          .ceil()
      : null;

  int? get minutesUntilNextLevel => nextLevelAtEpochMsUtc != null
      ? minutesUntilNextLevelAt(DateTime.now().toUtc())
      : null;
}
