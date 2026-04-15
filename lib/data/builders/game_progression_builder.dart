import '../../domain/models/game/game_progression_state.dart';
import '../storage/entities/game_progression_entity.dart';

class GameProgressionEntityBuilder {
  static GameProgressionState fromEntity(GameProgressionEntity entity) =>
      GameProgressionState(
        currentLevelIndex: entity.currentLevelIndex,
        handsFromLevelStart: entity.handsFromLevelStart,
        levelTimerStartMsUtc: entity.levelTimerStartMsUtc,
      );

  static GameProgressionEntity toEntity(GameProgressionState model) =>
      GameProgressionEntity(
        currentLevelIndex: model.currentLevelIndex,
        handsFromLevelStart: model.handsFromLevelStart,
        levelTimerStartMsUtc: model.levelTimerStartMsUtc,
      );
}
