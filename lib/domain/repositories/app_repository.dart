import '../models/config_model.dart';
import '../models/game/game_session_state.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_model.dart';

abstract class AppRepository {
  Future<ConfigModel> getConfig();

  Future<void> updateConfig(ConfigModel newConfig);

  Future<LobbyStateModel?> getLobbyState();

  Future<GameSessionState?> getGameSessionState();

  Future<void> updateLobbyState(LobbyStateModel newState);

  Future<void> updateGameSessionState(GameSessionState newState);

  Future<List<PlayerModel>> getSavedPlayers();

  Future<void> addPlayer(PlayerModel player);

  Future<void> removePlayer(String playerUid);
}
