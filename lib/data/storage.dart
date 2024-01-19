// Тут храняться классы для записи-чтения данных из/в системные данные

// ignore_for_file: avoid_renaming_method_parameters

import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config_model.dart';
import 'lobby.dart';
import 'logs.dart';

final LobbyStorage lobbyStorage = LobbyStorage();
final ConfigStorage configStorage = ConfigStorage();
final SavedPlayerStorage savedStorage = SavedPlayerStorage();

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

abstract class Storage<T> {
  late SharedPreferences prefs;

  Future<T> read();

  Future<void> write(T value);
}

class SavedPlayerStorage extends Storage<List<Player>> {
  @override
  Future<List<Player>> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final text = prefs.getString('saved');
      final content =
          (jsonDecode(text!) as List).map((i) => Player.fromJson(i)).toList();
      logs.writeLog('\n\tSAVED PLAYERS LOADED:\n [${[
        for (var x in content) x.show()
      ].join('\t')}]');

      return content;
    } catch (e) {
      logs.writeLog('EMPTY SAVED PLAYERS');
      return [];
    }
  }

  @override
  Future<void> write(List<Player> savedPlayers) async {
    String text = jsonEncode(savedPlayers.map((e) => e.toJson()).toList());
    logs.writeLog('Saved players info saved');
    prefs.setString('saved', text);
  }
}

class LobbyStorage extends Storage<Lobby> {
  @override
  Future<Lobby> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final text = prefs.getString('lobby');
      final content = Lobby.fromJson(jsonDecode(text!));
      logs.writeLog('LOBBY LOADED');
      return content;
    } catch (e) {
      // If encountering an error, return 0
      write(Lobby());
      logs.writeLog('ERROR OF READING LOBBY');
      return Lobby(); //новое пустое лобби
    }
  }

  @override
  Future<void> write(Lobby lobby) async {
    final text = jsonEncode(lobby);
    logs.writeLog('Lobby info saved');
    prefs.setString('lobby', text);
  }
}

class ConfigStorage extends Storage<Config> {
  @override
  Future<Config> read() async {
    prefs = await SharedPreferences.getInstance();
    try {
      final text = prefs.getString('config');
      final config = Config.fromJson(jsonDecode(text!));
      logs.writeLog(
        'Starting app...\n --- CONFIG LOADED ---\nfirstTime: ${config.firstTime}\nTheme:${config.themeIndex}',
      );
      return config;
    } catch (e) {
      // If encountering an error, return 0
      write(Config(0, true, ''));
      logs.writeLog('Starting app...\n --- ERROR OF READING CONFIG ---');
      //showToast("Welcome for the first time");
      return Config(); //новое пустое лобби
    }
  }

  @override
  Future<void> write(Config config) async {
    final text = jsonEncode(config);
    logs.writeLog('Config info saved');
    prefs.setString('config', text);
  }
}
