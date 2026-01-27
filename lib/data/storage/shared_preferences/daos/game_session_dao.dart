import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/logs.dart';
import '../../entities/game_session_entity.dart';
import 'dao.dart';

class GameSessionDao extends Dao<GameSessionEntity> {
  @override
  String get key => 'GameSession';

  @override
  Future<GameSessionEntity?> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final value = prefs.getString(key);

      if (value != null) {
        final content = GameSessionEntity.fromJson(jsonDecode(value));
        logs.writeLog('GameSession LOADED');

        return content;
      }
    } catch (e) {
      logs.writeLog('ERROR OF READING SHARED GameSession');
    }

    return null;
  }

  @override
  Future<void> write(GameSessionEntity gameSession) async {
    prefs = await SharedPreferences.getInstance();

    final text = jsonEncode(gameSession);
    logs.writeLog('SharPref: GameSession info saved');
    prefs.setString(key, text);
  }
}
