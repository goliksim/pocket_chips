import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/game/game_session_state.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

class MockAppRepository implements AppRepository {
  LobbyStateModel lobbyState;
  GameSessionState? gameSessionState;

  MockAppRepository({
    required this.lobbyState,
    required this.gameSessionState,
  });

  @override
  Future<void> addPlayer(PlayerModel player) async {}

  @override
  Future<void> changeProVersion(bool isPro) async {}

  @override
  Future<void> removePlayer(String playerUid) async {}

  @override
  Future<void> updatePlayer(PlayerModel player) async {}

  @override
  Future<ConfigModel> getConfig() async => ConfigModel.defaults('test');

  @override
  Future<LobbyStateModel?> getLobbyState() async => lobbyState;

  @override
  Future<GameSessionState?> getGameSessionState() async => gameSessionState;

  @override
  Future<List<PlayerModel>> getSavedPlayers() async => <PlayerModel>[];

  @override
  Future<bool> isProVersion() async => true;

  @override
  Future<void> updateConfig(ConfigModel newConfig) async {}

  @override
  Future<void> updateGameSessionState(GameSessionState newState) async {
    gameSessionState = newState;
  }

  @override
  Future<void> updateLobbyState(LobbyStateModel newState) async {
    lobbyState = newState;
  }
}
