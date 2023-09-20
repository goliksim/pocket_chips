// КЛАСС ИГРОКА И ЛОББИ, ХРАНЯЩИЙ ОСНОВНУЮ ИНФОРМАЦИЮ О СОСТОЯНИИ ИГРЫ

//глобальная переменная лобби
import 'storage_notshared.dart';


late Lobby thisLobby = Lobby();
List<Player> savedPlayers = [];

// Класс игрока
class Player {
  Player(this.name, this.assetUrl, this.bank, [this.isActive = false]);

  String name; // Имя
  String assetUrl; // Логотип
  int bank = 0; // Банк
  bool isActive = false;
  int bid = 0;
  //Функция обновления денег
  void changeBank(int newbank) {
    bank = newbank;
  }
 
  Player copy(){
    return Player(name,assetUrl,bank,true);
  }

 String show(){
  return '$name: $bank/$bid/$isActive';
 }

  //пишем в json
  Map toJson() => {
    'name': name,
    'assetUrl': assetUrl,
    'bank': bank,
    'active': isActive,
    'bid': bid
    
  };
  //читаем из json
  Player.fromJson(Map<String, dynamic> json): 
    name = json['name'], 
    assetUrl = json['assetUrl'], 
    bank = json['bank'], 
    isActive = json['active'], 
    bid = json['bid'];//bids = json['bids'];

  @override
  //перегруженный оператор == для недобавления существующих игроков
  bool operator ==(covariant Player other) =>
      ((name == other.name) && (assetUrl == other.assetUrl));
      
  // Ругается, что я не перегружаю хешкод (ссылку на объект). Но нам не важно, один это объект или нет, главное чтобы они были разные по значению.
}

int maxPlayerCount = 10;

class Lobby {
   Lobby({
        this.lobbyPlayers = const [],   
        this.lobbyBank = 5000,
        this.lobbySmallBlind = 25,
        this.lobbyAnte = 0,
        this.lobbyAnteBool = false,
        
        /*
        this.lobbyAutoBool = false,
        this.lobbyAutoTime = 15,
        this.lobbyEveryLapBool = false,
        this.lobbyFactor = 2.0,
        this.lobbyFirstAnte =1,
        */
        }) ;

  void add(Player newPlayer){
    lobbyPlayers.add(newPlayer);
  }

  String show(){
    String text = 'Players count: ${lobbyPlayers.length}\n';
    text+='[';
    for(Player a in lobbyPlayers){
      text+=a.show()+'\t';
    }
    text+=']\n';
    text+='lobbyIsActive: $lobbyIsActive\tlobbyState: $lobbyState\tdealerIndex: $dealerIndex\tfirstPlayerIndex: $firstPlayerIndex\tlobbyIndex: $lobbyIndex\n';
    text+='lobbyBank: $lobbyBank\tlobbySmallBlind: $lobbySmallBlind\n';
    text+='lobbyAnte: $lobbyAnte\tlobbyAutoBool: $lobbyAnteBool\n';
    text+='elementsOffset: $elementsOffset\tlobbyRandomOffset: $lobbyRandomOffset\n';
    
   
    /*
    text+='lobbyEveryLapBool ${lobbyEveryLapBool}\n';
    text+='lobbyFactor: ${lobbyFactor}\nlobbyAutoTime: ${lobbyAutoTime}\nlobbyFirstAnte: ${lobbyFirstAnte}\n';
    */
    return text;
  }
  void mixPlayersPosition(){
    elementsOffset=(elementsOffset.abs()+1)%lobbyPlayers.length;
    logs.writeLog('elementsOffset: $elementsOffset');
  }
  void reset(){
    for (Player player in lobbyPlayers){
      player.bank = lobbyBank;
    }
    lobbyIndex = -1;
    lobbyState = 5;
    dealerIndex = 0;
    lobbyIsActive = false;
    firstPlayerIndex = -1;
    lapCount = 0;
    bigBlindIndex = 0;
    logs.writeLog('Lobby reset with:\n lobbyBank: $lobbyBank');
  }
  
  // активное состояние
  bool lobbyIsActive = false;
  // список игроков
  List<Player> lobbyPlayers = [];
  // текущий смол блайнд
  int lobbySmallBlind; 
  // текущий игрок  
  int lobbyIndex = -1;    
  // состояние игры
  int lobbyState = 5;  
  // отступы для UI
  int elementsOffset = 0;
  // банк лобби
  int lobbyBank;
  // смолБлайн первый игрок
  int dealerIndex = 0;
  int firstPlayerIndex = -1;
  int bigBlindIndex = 0;
  int lapCount = 0;
  //анте?
  bool lobbyAnteBool;
  // текущий анте
  int lobbyAnte;
  List<double> lobbyRandomOffset  = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  /*
  //автоматическое повышение?
  bool lobbyAutoBool;
  //каждый круг?
  bool lobbyEveryLapBool;
  //множитель повышения
  double lobbyFactor;
  //период повышения
  int lobbyAutoTime;
  int lobbyFirstAnte;
  */

  //пишем в json
  Map toJson() => {
    
    'lobbyIsActive': lobbyIsActive,
    'lobbyPlayers': lobbyPlayers,
    'lobbySmallBlind': lobbySmallBlind,
    'lobbyIndex': lobbyIndex,
    'lobbyState': lobbyState,
    'elementsOffset':elementsOffset,
    'lobbyBank': lobbyBank,
    'dealerIndex': dealerIndex,
    'firstPlayerIndex': firstPlayerIndex,
    'lobbyAnteBool': lobbyAnteBool,
    'lobbyAnte': lobbyAnte,
    'lobbyRandomOffset' : lobbyRandomOffset,
    'bigBlindIndex': bigBlindIndex,
    'lapCount': lapCount
  };

  //читаем из json
  Lobby.fromJson(Map<String, dynamic> json): 
    //lobbyRandomOffset = json['lobbyRandomOffset'].map<double>((i) => i).toList(),
    lobbyIsActive = json['lobbyIsActive'], 
    lobbyPlayers = json['lobbyPlayers'].map<Player>((i) => Player.fromJson(i)).toList(), 
    lobbySmallBlind= json['lobbySmallBlind'], 
    lobbyIndex= json['lobbyIndex'], 
    lobbyState= json['lobbyState'], 
    elementsOffset=json['elementsOffset'],
    lobbyBank= json['lobbyBank'], 
    dealerIndex= json['dealerIndex'], 
    firstPlayerIndex= json['firstPlayerIndex'], 
    lobbyAnteBool= json['lobbyAnteBool'],
    lobbyAnte= json['lobbyAnte'],
    bigBlindIndex=json['bigBlindIndex'],
    lapCount=json['lapCount'],
    lobbyRandomOffset=json['lobbyRandomOffset'].map<double>((e) => jsonToDouble(e)).toList();//bids = json['bids'];
}

double jsonToDouble(dynamic value) {
   return value.toDouble();
}
