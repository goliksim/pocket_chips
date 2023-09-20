// Тут храняться классы для записи-чтения данных из/в системные данные

import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'lobby.dart';

Config thisConfig = Config(0,false);

final LobbyStorage lobbyStorage = LobbyStorage();
final ConfigStorage configStorage = ConfigStorage();
final SavedPlayerStorage savedStorage = SavedPlayerStorage();
final Logs logs = Logs();

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class Logs {
 Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/pocketchips/poker_chips.log').create(recursive: true);
  }

  Future<File> writeLog(String text) async {
    final file = await _localFile;

    var date = DateTime.now();
    String finalDateString = [date.year,date.month,date.day].join('/') +' '+[date.hour,date.minute,date.second].join(':')+'.'+date.millisecond.toString()+'\t';
    file.writeAsStringSync( finalDateString + text + '\n',mode: FileMode.append);
    log(finalDateString + text);
    return file;
  }
}
 

class SavedPlayerStorage {

  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/pocketchips/savedplayers.json').create(recursive: true);
  }

  Future<List<Player>> readPlayers() async {
    try {
      final file = await _localFile;
      final content = (jsonDecode(await file.readAsString()) as List).map((i) =>
              Player.fromJson(i)).toList();
      logs.writeLog('\n\tSAVED PLAYERS LOADED:\n [${[for (var x in content) x.show()].join('\t')}]');
      return content;
    } catch (e) {
      logs.writeLog('EMPTY SAVED PLAYERS');
      return [];
    }
  }

  Future<File> writePlayers(List<Player> savedPlayers) async {
    final file = await _localFile;
    file.writeAsString(jsonEncode(savedPlayers.map((e) => e.toJson()).toList()));
    logs.writeLog('Saved players info saved');
    return file;
  }
}

class LobbyStorage {
  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/pocketchips/activelobby.json').create(recursive: true);//('C:/Users/golev/Desktop/activelobby.json'); //('$path/activelobby.json');
  }

  Future<Lobby> readLobby() async {
      
    try {
      final file = await _localFile;
      final content = Lobby.fromJson(jsonDecode(await file.readAsString()));
      return content;
    } catch (e) {
      // If encountering an error, return 0
      writeLobby(Lobby());
      logs.writeLog("Starting app...\n ERROR OF READING LOBBY");
      return Lobby(); //новое пустое лобби
    }
    
  }

  Future<File> writeLobby(Lobby lobby) async {
    final file = await _localFile;
    file.writeAsString(jsonEncode(lobby));
    logs.writeLog("Lobby info saved");
    return file;
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
  Future<File> get _localFile async {
    final path = await localPath;
    //print(path);
    return File('$path/pocketchips/config.json').create(recursive: true); //('C:/Users/golev/Desktop/config.json');
  }

  Future<Config> readConfig() async {
    
    try {
      final file = await _localFile;
      final config = Config.fromJson(jsonDecode(await file.readAsString()));
      logs.writeLog("Starting app...\n --- CONFIG LOADED ---\nfirstTime: ${config.firstTime}");
      return config;
    } catch (e) {
      // If encountering an error, return 0
      writeConfig(Config(0,true));
      logs.writeLog("Starting app...\n --- ERROR OF READING CONFIG ---");
      //showToast("Welcome for the first time");
      return Config(); //новое пустое лобби
      
    }
    
  }

  Future<File> writeConfig(Config config) async {
    final file = await _localFile;
    file.writeAsString(jsonEncode(config));
    logs.writeLog("Config info saved");
    return file;
  }
}

