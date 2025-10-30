import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/logs.dart';
import '../../entities/player_entity.dart';
import 'dao.dart';

class SavedPlayerDao extends Dao<List<PlayerEntity>> {
  @override
  String get key => 'saved';

  @override
  Future<List<PlayerEntity>> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final value = prefs.getString(key);

      if (value == null) {
        return _oldRead();
      }

      final content = (jsonDecode(value) as List)
          .map((i) => PlayerEntity.fromJson(i))
          .toList();
      logs.writeLog('\n\tSAVED PLAYERS LOADED:\n [${[
        for (var x in content) x.toString(),
      ].join('\t')}]');

      return content;
    } catch (e) {
      logs.writeLog('EMPTY SHARED SAVED PLAYERS');

      return List<PlayerEntity>.empty();
    }
  }

  @override
  Future<void> write(List<PlayerEntity> savedPlayers) async {
    String text = jsonEncode(savedPlayers.map((e) => e.toJson()).toList());
    logs.writeLog('Saved players info saved');
    prefs.setString(key, text);
  }

  Future<List<PlayerEntity>> _oldRead() async {
    try {
      final file = await localFile('savedplayers');
      final content = (jsonDecode(await file.readAsString()) as List)
          .map((i) => PlayerEntity.fromJson(i))
          .toList();
      logs.writeLog('\n\tSAVED PLAYERS LOADED:\n [${[
        for (var x in content) x.toString(),
      ].join('\t')}]');

      return content;
    } catch (e) {
      logs.writeLog('EMPTY SAVED PLAYERS');

      return List<PlayerEntity>.empty();
    }
  }

  /// Add a player to saved list. If a player with the same uid exists, it will be replaced.
  Future<void> add(PlayerEntity player) async {
    final current = await read();
    // ensure we work with a mutable list
    final list = current.toList();

    // remove existing with same uid
    list.removeWhere((p) => p.uid == player.uid);
    list.add(player);

    await write(list);
  }

  /// Delete a saved player by uid. If uid not found, nothing happens.
  Future<void> deleteByUid(String uid) async {
    final current = await read();
    final list = current.toList();

    final before = list.length;
    list.removeWhere((p) => p.uid == uid);
    final after = list.length;

    // write back only if something changed
    if (after < before) {
      await write(list);
    }
  }
}
