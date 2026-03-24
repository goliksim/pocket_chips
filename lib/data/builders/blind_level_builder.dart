import '../../domain/models/game/blind_level_model.dart';
import '../storage/entities/blind_level_entity.dart';

class BlindLevelEntityBuilder {
  static BlindLevelModel fromEntity(BlindLevelEntity entity) => BlindLevelModel(
        smallBlind: entity.smallBlind,
        anteType: entity.anteType,
        anteValue: entity.anteValue,
      );

  static BlindLevelEntity toEntity(BlindLevelModel model) => BlindLevelEntity(
        smallBlind: model.smallBlind,
        anteType: model.anteType,
        anteValue: model.anteValue,
      );
}
