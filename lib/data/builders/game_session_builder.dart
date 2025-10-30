import '../../domain/models/game/game_session_state.dart';
import '../storage/entities/game_session_entity.dart';

class GameSessionEntityBuilder {
  static GameSessionState fromEntity(GameSessionEntity entity) {
    return GameSessionState(
      currentPlayerUid: entity.currentPlayerUid,
      lapCounter: entity.lapCounter,
      bets: entity.bets,
      foldedOrInactive: entity.foldedOrInactive,
    );
  }

  static GameSessionEntity toEntity(GameSessionState model) {
    return GameSessionEntity(
      currentPlayerUid: model.currentPlayerUid,
      lapCounter: model.lapCounter,
      bets: model.bets,
      foldedOrInactive: model.foldedOrInactive,
    );
  }
}
