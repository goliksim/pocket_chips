import '../../domain/models/player/player_model.dart';
import '../storage/entities/player_entity.dart';

class PlayerEntityBuilder {
  static PlayerModel fromEntity(PlayerEntity entity) => PlayerModel(
        uid: entity.uid,
        name: entity.name,
        assetUrl: entity.assetUrl,
      );

  static PlayerEntity toEntity(PlayerModel model) => PlayerEntity(
        uid: model.uid,
        name: model.name,
        assetUrl: model.assetUrl,
      );
}
