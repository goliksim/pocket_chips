import '../../domain/models/game/game_progression_state.dart';
import '../../domain/models/game/game_session_state.dart';
import '../storage/entities/game_session_entity.dart';
import 'game_progression_builder.dart';

class GameSessionEntityBuilder {
  static GameSessionState fromEntity(GameSessionEntity entity) =>
      GameSessionState(
        bets: entity.bets,
        anteBets: entity.anteBets,
        lapCounter: entity.lapCounter,
        foldedPlayers: entity.foldedPlayersInactive,
        sitOutPlayers: entity.sitOutPlayers,
        progressionState: entity.progressionState == null
            ? const GameProgressionState()
            : GameProgressionEntityBuilder.fromEntity(entity.progressionState!),
        currentPlayerUid: entity.currentPlayerUid,
        firstPlayerUid: entity.firstPlayerUid,
      );

  static GameSessionEntity toEntity(GameSessionState model) =>
      GameSessionEntity(
        bets: model.bets,
        anteBets: model.anteBets,
        lapCounter: model.lapCounter,
        foldedPlayersInactive: model.foldedPlayers,
        sitOutPlayers: model.sitOutPlayers,
        progressionState:
            GameProgressionEntityBuilder.toEntity(model.progressionState),
        currentPlayerUid: model.currentPlayerUid,
        firstPlayerUid: model.firstPlayerUid,
      );
}
