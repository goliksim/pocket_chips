import '../../domain/models/player/player_model.dart';
import '../storage/entities/player_entity.dart';

class PlayerEntityBuilder {
  static PlayerModel fromEntity(PlayerEntity entity) {
    return PlayerModel(
      uid: entity.uid,
      name: entity.name,
      assetUrl: entity.assetUrl,
    );
  }

  static PlayerEntity toEntity(PlayerModel model) {
    return PlayerEntity(
      uid: model.uid,
      name: model.name,
      assetUrl: model.assetUrl,
    );
  }
}
