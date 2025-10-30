import '../../domain/models/lobby/lobby_state_model.dart';
import '../../domain/models/player/player_model.dart';
import '../storage/entities/lobby_state_entity.dart';
import 'player_builder.dart';

class LobbyStateEntityBuilder {
  static LobbyStateModel fromEntity(LobbyStateEntity entity) {
    return LobbyStateModel(
      players: entity.players
              ?.map((p) => PlayerEntityBuilder.fromEntity(p))
              .toList() ??
          List<PlayerModel>.empty(),
      banks: entity.banks ?? <String, int>{},
      smallBlindValue: entity.smallBlindValue,
      dealerId: entity.dealerId,
      defaultBank: entity.defaultBank,
      gameState: entity.gameState,
    );
  }

  static LobbyStateEntity toEntity(LobbyStateModel model) {
    return LobbyStateEntity(
      players: model.players
          .map(
            (p) => PlayerEntityBuilder.toEntity(p),
          )
          .toList(),
      smallBlindValue: model.smallBlindValue,
      banks: model.banks,
      dealerId: model.dealerId,
      defaultBank: model.defaultBank,
      gameState: model.gameState,
    );
  }
}
