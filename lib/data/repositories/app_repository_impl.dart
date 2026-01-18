import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/models/config_model.dart';
import '../../domain/models/game/game_session_state.dart';
import '../../domain/models/lobby/lobby_state_model.dart';
import '../../domain/models/player/player_id.dart';
import '../../domain/models/player/player_model.dart';
import '../../domain/repositories/app_repository.dart';
import '../builders/config_builder.dart';
import '../builders/game_session_builder.dart';
import '../builders/lobby_state_builder.dart';
import '../builders/player_builder.dart';
import '../storage/secure_storage/secure_storage.dart';
import '../storage/shared_preferences/shared_preferences_storage.dart';

class AppRepositoryImpl implements AppRepository {
  final SharedPreferencesStorage localStorage;
  final SecureStorage secureStorage;

  AppRepositoryImpl({
    required this.localStorage,
    required this.secureStorage,
  });

  @override
  Future<ConfigModel> getConfig() async {
    final entity = await localStorage.configDao.read();

    final version =
        entity?.version ?? (await PackageInfo.fromPlatform()).version;

    if (entity == null) {
      return ConfigModel.defaults(version);
    }

    return ConfigEntityBuilder.fromEntity(entity);
  }

  @override
  Future<void> updateConfig(ConfigModel newConfig) async {
    final entity = ConfigEntityBuilder.toEntity(newConfig);

    await localStorage.configDao.write(entity);
  }

  @override
  Future<bool> isProVersion() async => secureStorage.proVersionDao.read();

  @override
  Future<void> changeProVersion(bool isPro) async =>
      secureStorage.proVersionDao.write(isPro);

  @override
  Future<LobbyStateModel?> getLobbyState() async {
    final entity = await localStorage.lobbyDao.read();

    if (entity == null) {
      return null;
    }

    return LobbyStateEntityBuilder.fromEntity(entity);
  }

  @override
  Future<void> updateLobbyState(LobbyStateModel newState) async {
    final entity = LobbyStateEntityBuilder.toEntity(newState);

    await localStorage.lobbyDao.write(entity);
  }

  @override
  Future<void> updateGameSessionState(GameSessionState newState) async {
    final entity = GameSessionEntityBuilder.toEntity(newState);

    await localStorage.gameSessionDao.write(entity);
  }

  @override
  Future<List<PlayerModel>> getSavedPlayers() async {
    final entity = await localStorage.savedPlayersDao.read();

    return entity.map(PlayerEntityBuilder.fromEntity).toList();
  }

  @override
  Future<void> addPlayer(PlayerModel player) =>
      localStorage.savedPlayersDao.add(PlayerEntityBuilder.toEntity(player));

  @override
  Future<void> updatePlayer(PlayerModel player) => localStorage.savedPlayersDao
      .updatePlayer(PlayerEntityBuilder.toEntity(player));

  @override
  Future<void> removePlayer(PlayerId playerUid) =>
      localStorage.savedPlayersDao.deleteByUid(playerUid);

  @override
  Future<GameSessionState?> getGameSessionState() async {
    final entity = await localStorage.gameSessionDao.read();

    if (entity == null) {
      return null;
    }

    return GameSessionEntityBuilder.fromEntity(entity);
  }
}
