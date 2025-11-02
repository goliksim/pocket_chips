import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/logs.dart';
import '../../entities/config_entity.dart';
import 'dao.dart';

class ConfigDao extends Dao<ConfigEntity> {
  @override
  String get key => 'config';

  @override
  Future<ConfigEntity?> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final value = prefs.getString(key);

      if (value == null) {
        return _oldRead();
      }

      final config = ConfigEntity.fromJson(jsonDecode(value));
      logs.writeLog(
        'Starting app...\n --- CONFIG LOADED ---\n${config.toString()}}',
      );

      return config;
    } catch (e) {
      logs.writeLog('Starting app...\n --- ERROR OF READING SHARED CONFIG ---');

      return null;
    }
  }

  @override
  Future<void> write(ConfigEntity config) async {
    prefs = await SharedPreferences.getInstance();

    final text = jsonEncode(config);
    logs.writeLog('Config info saved');
    prefs.setString(key, text);
  }

  Future<ConfigEntity?> _oldRead() async {
    try {
      final file = await localFile(key);
      final config = ConfigEntity.fromJson(
        jsonDecode(await file.readAsString()),
      );
      logs.writeLog(
        'Starting app...\n --- CONFIG LOADED ---\n${config.toJson()}',
      );

      return config;
    } catch (e) {
      logs.writeLog('Starting app...\n --- ERROR OF READING CONFIG ---');

      return null; //новое пустое лобби
    }
  }
}
