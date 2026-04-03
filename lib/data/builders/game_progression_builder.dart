import '../../domain/models/game/game_progression_state.dart';
import '../storage/entities/game_progression_entity.dart';

class GameProgressionEntityBuilder {
  static GameProgressionState fromEntity(GameProgressionEntity entity) =>
      GameProgressionState(
        currentLevelIndex: entity.currentLevelIndex,
        handsUntilNextLevel: entity.handsUntilNextLevel,
        nextLevelAtEpochMsUtc: entity.nextLevelAtEpochMsUtc,
      );

  static GameProgressionEntity toEntity(GameProgressionState model) =>
      GameProgressionEntity(
        currentLevelIndex: model.currentLevelIndex,
        handsUntilNextLevel: model.handsUntilNextLevel,
        nextLevelAtEpochMsUtc: model.nextLevelAtEpochMsUtc,
      );
}
