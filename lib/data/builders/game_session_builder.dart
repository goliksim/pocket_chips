import '../../domain/models/game/game_session_state.dart';
import '../storage/entities/game_session_entity.dart';

class GameSessionEntityBuilder {
  static GameSessionState fromEntity(GameSessionEntity entity) {
    return GameSessionState(
      bets: entity.bets,
      lapCounter: entity.lapCounter,
      foldedPlayers: entity.foldedPlayersInactive,
      currentPlayerUid: entity.currentPlayerUid,
      firstPlayerUid: entity.firstPlayerUid,
    );
  }

  static GameSessionEntity toEntity(GameSessionState model) {
    return GameSessionEntity(
      bets: model.bets,
      lapCounter: model.lapCounter,
      foldedPlayersInactive: model.foldedPlayers,
      currentPlayerUid: model.currentPlayerUid,
      firstPlayerUid: model.firstPlayerUid,
    );
  }
}
