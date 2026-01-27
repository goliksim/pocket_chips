import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/logs.dart';
import '../../entities/lobby_state_entity.dart';
import 'dao.dart';

class LobbyDao extends Dao<LobbyStateEntity> {
  @override
  String get key => 'lobby';

  @override
  Future<LobbyStateEntity?> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final value = prefs.getString(key);

      if (value != null) {
        final content = LobbyStateEntity.fromJson(jsonDecode(value));
        logs.writeLog('LOBBY LOADED');

        return content;
      }
    } catch (e) {
      logs.writeLog('ERROR OF READING SHARED LOBBY');

      return null;
    }
    return null;
  }

  @override
  Future<void> write(LobbyStateEntity lobby) async {
    prefs = await SharedPreferences.getInstance();

    final text = jsonEncode(lobby);
    logs.writeLog('SharPref: Lobby info saved');
    prefs.setString(key, text);
  }
}
