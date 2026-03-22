import 'daos/config_dao.dart';
import 'daos/game_session_dao.dart';
import 'daos/lobby_dao.dart';
import 'daos/saved_players_dao.dart';

class SharedPreferencesStorage {
  final LobbyDao lobbyDao = LobbyDao();
  final ConfigDao configDao = ConfigDao();
  final SavedPlayerDao savedPlayersDao = SavedPlayerDao();
  final GameSessionDao gameSessionDao = GameSessionDao();
}
