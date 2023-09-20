// Тут храняться классы для записи-чтения данных из/в системные данные

import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'lobby.dart';

Config thisConfig = Config(0,false);

final LobbyStorage lobbyStorage = LobbyStorage();
final ConfigStorage configStorage = ConfigStorage();
final SavedPlayerStorage savedStorage = SavedPlayerStorage();
final Logs logs = Logs();



class Logs {

  Future<void> writeLog(String text) async {
    var date = DateTime.now();
    String finalDateString = [date.year,date.month,date.day].join('/') +' '+[date.hour,date.minute,date.second].join(':')+'.'+date.millisecond.toString()+'\t';
    log(text); 
  }
}
 

class SavedPlayerStorage {
  late SharedPreferences prefs ;

  Future<List<Player>> readPlayers() async {
    prefs = await SharedPreferences.getInstance()  ;
    try {
      print('loading players');
      final text = prefs.getString('saved');
      print(text);
      final content = (jsonDecode(text!) as List).map((i) =>
              Player.fromJson(i)).toList();
      logs.writeLog('\n\tSAVED PLAYERS LOADED:\n [${[for (var x in content) x.show()].join('\t')}]');

      return content;
    } catch (e) {
      logs.writeLog('EMPTY SAVED PLAYERS');
      return [];
    }
  }

  Future<void> writePlayers(List<Player> savedPlayers) async {
    print('save player');
    String text  = jsonEncode(savedPlayers.map((e) => e.toJson()).toList());
    logs.writeLog('Saved players info saved');
    prefs.setString('saved',text);
  }
}

class LobbyStorage {
  late SharedPreferences prefs ;

  Future<Lobby> readLobby() async {
    prefs = await SharedPreferences.getInstance()  ;
    try {
      final text = prefs.getString('lobby');
      final content = Lobby.fromJson(jsonDecode(text!));
      return content;
    } catch (e) {
      // If encountering an error, return 0
      writeLobby(Lobby());
      logs.writeLog("Starting app...\n ERROR OF READING LOBBY");
      return Lobby(); //новое пустое лобби
    }
    
  }

  Future<void> writeLobby(Lobby lobby) async {
    final text = jsonEncode(lobby);
    logs.writeLog("Lobby info saved");
    prefs.setString('lobby',text);
  }
}

class Config {
   

  Config([this.themeIndex = 0, this.firstTime = true]);
  int themeIndex; // тема
  bool firstTime;
  //пишем в json
  Map toJson() => {
    'theme': themeIndex,
    'first': firstTime
  };
  //читаем из json
  Config.fromJson(Map<String, dynamic> json): 
    themeIndex = json['theme'],
    firstTime = json['first'];
}

class ConfigStorage {
  late SharedPreferences prefs ;
  Future<Config> readConfig() async {
    prefs = await SharedPreferences.getInstance()  ;
    try {
      final text = prefs.getString('config');
      print(text);
      final config = Config.fromJson(jsonDecode(text!));
      logs.writeLog("Starting app...\n --- CONFIG LOADED ---\nfirstTime: ${config.firstTime}\nTheme:${config.themeIndex}");
      return config;
    } catch (e) {
      // If encountering an error, return 0
      writeConfig(Config(0,true));
      logs.writeLog("Starting app...\n --- ERROR OF READING CONFIG ---");
      //showToast("Welcome for the first time");
      return Config(); //новое пустое лобби
    }
    
  }

  Future<void> writeConfig(Config config) async {
    final text = jsonEncode(config);
    logs.writeLog("Config info saved");
    prefs.setString('config',text);
  }
}

