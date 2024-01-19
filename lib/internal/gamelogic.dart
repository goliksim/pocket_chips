//ОСНОВНАЯ ИГРОВАЯ ЛОГИКА
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pocket_chips/data/logs.dart';
import 'package:pocket_chips/pages/gamepage/winner_page.dart';

import '../data/storage.dart';
import '../data/lobby.dart';
import '../ui/transitions.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';
import 'localization.dart';

Game thisGame = Game();

class Game {
  //список названий этапов игры
  List<String> gameStateNameList = [
    LocaleManager.locale.game_pflop,
    LocaleManager.locale.game_flop,
    LocaleManager.locale.game_turn,
    LocaleManager.locale.game_river,
    LocaleManager.locale.game_shdw,
    LocaleManager.locale.game_break
  ];
  Text gameStateName = Text(
    LocaleManager.locale.game_welc,
    style: TextStyle(color: thisTheme.primaryColor),
  );

  //Минимальная сумма для ставки
  int raiseBank = 0;

  //Уравнены ли все ставки
  bool bidsEqual = false;

  int notZeroPlayers = 0;
  //bool raiseButtonPressed = false;

  Function()? callback;
  BuildContext? context;

  bool get canPlay =>
      thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1;

  void allIN() {
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid +=
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank;
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank = 0;
    newPlayer();
  }

  void bet(int bid) {
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank -= bid;
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid += bid;
    thisGame.newPlayer();
  }

  bool fold() {
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].isActive = false;
    if (thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1) {
      newPlayer();
      return false;
    } else {
      return true;
    }
  }

  // меняем отступы у игроков
  void changeOffset() {
    Random rnd = Random();

    List<double> arr = [];
    for (int a = 0; a < maxPlayerCount; a++) {
      arr.add((rnd.nextInt(40) - 20) / 360 * 2 * pi);
    }
    arr[0] = 0.0;
    thisLobby.lobbyRandomOffset = arr;
    lobbyStorage.write(thisLobby);
  }

  // начало ставок
  void startBetting() {
    //(!thisLobby.lobbyIsActive )&&
    if ((thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1)) {
      logs.writeLog('Start Betting. Lobby is active}');
      thisLobby.lobbyIsActive = true;
      thisLobby.lapCount = 0;
      thisLobby.lobbyState = 0;
      thisLobby.bigBlindIndex = firstBlind(thisLobby.bigBlindIndex);
      lobbyStorage.write(thisLobby);
      newPlayer(index: thisLobby.firstPlayerIndex);
      callback!();
      changeText(gameStateNameList[thisLobby.lobbyState]);
    } else {
      showToast(LocaleManager.locale.toast_moreplay);
    }
  }

  // переходы между игроками
  int newPlayer({int index = 100}) {
    //print(bigBlindIndex);

    if (index == 100) {
      thisLobby.lobbyIndex += 1;
      if (thisLobby.lobbyIndex == thisLobby.lobbyPlayers.length) {
        logs.writeLog('End of circle. Move to first in list');
        thisLobby.lobbyIndex = 0;
      }
    } else {
      thisLobby.lobbyIndex = index;
    }

    //print(thisLobby.lapCount);
    //print(thisGame.bidsEqual);
    //print(thisGame.waitForBidsEqual());

    if ((thisLobby.lobbyPlayers
        .map((e) => e.bank)
        .where((element) => element != 0)
        .isEmpty)) {
      logs.writeLog('No one player with money\n${thisLobby.lobbyPlayers.map(
        (e) => [e.name, e.bank],
      )}');
      newLap();
      return 0;
    }

    if (index == 100) {
      var thisBidsEqual = waitForBidsEqual();

      var firstLap = thisLobby.lapCount <= 0;
      //print('${!bidsEqual}$thisBidsEqual$firstLap${thisLobby.lapCount}');
      if (!bidsEqual && thisBidsEqual && firstLap) {
        //bidsEqual = waitForBidsEqual();
        //print('Case of normal on first lap equal');
        newState();
        return 0;
      } else {
        //print('case 2 ${thisLobby.lobbyIndex == thisLobby.firstPlayerIndex}${!firstLap}$thisBidsEqual');
        if (thisLobby.lobbyIndex == thisLobby.firstPlayerIndex &&
            !firstLap &&
            thisBidsEqual) {
          //print('Case of first lap equal');
          newState();
          return 0;
        }
      }
    }
    if (notZeroPlayers < 2) {
      if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid ==
          thisLobby.maxBid) {
        newLap();
      }
    }

    /*
    //проверка на выравнивание ставок
    if (waitForBidsEqual()) {

      if (!(thisLobby.lobbyState == 0 && thisLobby.lobbyIndex == bigBlindIndex && thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid == thisLobby.lobbySmallBlind * 2)) {
        if ((!bidsEqual || thisLobby.lobbyIndex == thisLobby.firstPlayerIndex) && (index == 100)) {
          bidsEqual = waitForBidsEqual();
          //print('bids equal');
          print('sdkjhbsdhjbfsdmnb xcvmbnxcbvnxmc');
          newState();
          return 0;
        }
      }
    }*/
    //bidsEqual = waitForBidsEqual();
    logs.writeLog('Bids: ${thisLobby.lobbyPlayers.map(
          (e) => [e.name, e.bid].join(': '),
        ).join('\t')}');

    //пропуск лоха без денег
    if ((thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank <= 0)) {
      newPlayer();
      return 0;
    }
    //если челикс фолданул, скипаем его
    if (!thisLobby.lobbyPlayers[thisLobby.lobbyIndex].isActive) {
      newPlayer();
      return 0;
    }

    /*
    //если чел не может рейзить, скипаем его
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank<=minTmpFunction()){
      newPlayer();
      return 0;
    }
    */
    raiseBank = minTmpFunction(bidsEqual);
    bidsEqual = waitForBidsEqual();
    if (thisLobby.lobbyIndex == thisLobby.bigBlindIndex) {
      thisLobby.lapCount += 1;
    }
    // print('raisebank');
    //print(raiseBank);
    if (index == 100) {
      gameStateName = Text(
        '${LocaleManager.locale.game_turn1}\u00A0${LocaleManager.locale.game_turn2}\u00A0${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}',
        style: TextStyle(color: thisTheme.onBackground),
      );
    }
    callback!();
    logs.writeLog(
      'Turn of ${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}',
    );
    lobbyStorage.write(thisLobby);
    return 0;
  }

  // подсчет величины рейза-ререйза
  int minTmpFunction(bool bidsEqual) {
    //Сколько нужно добавить для выравнивания
    int toEqual = thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max) -
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid;
    //print('toEqual');
    //print(toEqual);
    //подходит под ставку или ход в олл ин, если остался условно 1 бакс (бет)
    List<int> bids = thisLobby.lobbyPlayers.map((e) => e.bid).toSet().toList();
    bids.sort();
    //последнее повышение
    int lastRaise = 0;
    if (bids.length > 1) {
      lastRaise = bids[bids.length - 1] - bids[bids.length - 2];
    }
    // если lastrise = 0, toequal = 0 , то мин рейз - бигблайнд
    //print('lastRaise');
    //print(lastRaise);

    //result = toEqual + [(lastRaise - thisLobby.lobbySmallBlind*2),thisLobby.lobbySmallBlind*2].max;

    int result =
        toEqual + [lastRaise, thisLobby.lobbySmallBlind * 2].reduce(max);
    //var result = [(toEqual + lastRaise + ((lastRaise+toEqual==0)?thisLobby.lobbySmallBlind*2:0) + ((lastRaise+toEqual==0 && thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank<thisLobby.lobbySmallBlind*2)?thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank:0)),
    //((thisLobby.lobbyState==0)?4:2)*thisLobby.lobbySmallBlind - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid].max;
    //print("minTmpFunction - $result");
    return result;
  }

  // временное изменение текста
  void changeText(String text) async {
    gameStateName = Text(
      text,
      style: TextStyle(
        color: thisTheme.primaryColor,
      ),
    ); //если конец, то переходим в новый круг
    callback!();
    await Future.delayed(const Duration(seconds: 4));
    gameStateName = Text(
      '${LocaleManager.locale.game_turn1}\u00A0${LocaleManager.locale.game_turn2}\u00A0${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}',
      style: TextStyle(color: thisTheme.onBackground),
    );

    callback!();
  }

  // новая улица
  void newState() async {
    //проверяем, шобы ставки были одинаковы

    if (waitForBidsEqual()) {
      //переходим в новое состояние
      thisLobby.lapCount += 1;
      thisLobby.lobbyState += 1;
      logs.writeLog('NewState with lobbyState = ${thisLobby.lobbyState}');
      lobbyStorage.write(thisLobby);
    } else {}
    //после префлопа первый игрок - смол блайнд
    if (thisLobby.lobbyState == 1) {
      for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
        int localIndex =
            (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
        if (thisLobby.lobbyPlayers[localIndex].isActive) {
          thisLobby.firstPlayerIndex = localIndex;
          break;
        }
      }
    }
    if (thisLobby.lobbyState > 3) {
      await newLap();
      return null;
    } else {
      changeText(gameStateNameList[thisLobby.lobbyState]);
    }
    newPlayer(index: thisLobby.firstPlayerIndex);
    callback!();
  }

  // проверка на выравнивание ставок
  bool waitForBidsEqual() {
    bool notAllInBool = false;
    bool equalBool = false;
    notZeroPlayers = 0;

    //bool preFlop = false;
    var maxBid = thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max);
    for (Player player in thisLobby.lobbyPlayers) {
      equalBool = (player.isActive) && (player.bid != maxBid);
      notAllInBool = !((player.bid > 0) && (player.bank == 0));
      if (player.bank > 0) notZeroPlayers += 1;
      //preFlop = (player.isActive) && (player.bid == thisLobby.lobbySmallBlind*2);
      //if(!preFlop) return true;
      //pr(equalBool);
      if (equalBool && notAllInBool) {
        return false;
      }
    }
    //проверка на 1 оставшегося чела
    //print('notzero = $notZeroPlayers');
    if (notZeroPlayers < 2) return true;

    if (thisLobby.lapCount == 0) {
      return false;
    } else {
      return true;
    }
  }

  // новый круг
  Future newLap({bool folded = false}) async {
    thisLobby.lobbyState = 4;

    gameStateName =
        Text('Showdown', style: TextStyle(color: thisTheme.primaryColor));
    callback!();
    // ignore: await_only_futures
    if (!folded) {
      logs.writeLog('Call WinnerChooseWindow');
      await transitionDialog(
        barrierDismissible: false,
        duration: const Duration(milliseconds: 400),
        type: 'Scale1',
        //barrierColor: null,
        context: context,
        child: WillPopScope(
          onWillPop: () async => false,
          child: WinnerChooseWindow(thisLobby: thisLobby),
        ),
        builder: (BuildContext context) {
          return WinnerChooseWindow(thisLobby: thisLobby);
        },
      );
    }
    logs.writeLog('NEW Lap\tlobby state = 5\t lobbyIndex=-1;');

    //стираем старые ставки и тех, кто фолданул
    for (Player player in thisLobby.lobbyPlayers) {
      player.isActive = false;
      player.bid = 0;
      player.isActive = !(player.bank <= 0);
    }
    logs.writeLog(
        "Still Active players: ${thisLobby.lobbyPlayers.where((e) => e.isActive == true).map(
              (e) => [e.name, e.bid],
            ).join(' / ')}");

    // finding dealer
    for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
      int localIndex =
          (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
      if (thisLobby.lobbyPlayers[localIndex].isActive) {
        thisLobby
            .lobbyPlayers[thisLobby.dealerIndex % thisLobby.lobbyPlayers.length]
            .isDealer = true;

        thisLobby.setDealer(localIndex);
        logs.writeLog('new dealer index: $localIndex');
        break;
      }
    } // finding smallBlind
    thisLobby.lobbyState = 5;
    //await Future.delayed(Duration(milliseconds: 1));
    //changeText(gameStateNameList[thisLobby.lobbyState]);
    gameStateName = Text(
      LocaleManager.locale.game_break,
      style: TextStyle(color: thisTheme.primaryColor),
    );
    thisLobby.lobbyIndex = -1;
    callback!();
    /*
    firstBlind();
    
    pr("firstBlind text changing");
    lobbyStorage.writeLobby(thisLobby);
    setState(() {});
    changeText(gameStateNameList[thisLobby.lobbyState]);
    */
  }

  // начало игры
  void startGame() {
    thisGame.gameStateName = Text(
      LocaleManager.locale.game_welc,
      style: TextStyle(color: thisTheme.onBackground),
    );
    for (Player player in thisLobby.lobbyPlayers) {
      player.isActive = !(player.bank <= 0);
      //player.isActive = !(player.bank < thisLobby.lobbySmallBlind * 2);
      player.bid = 0;
    }
    bidsEqual = false;
    lobbyStorage.write(thisLobby);
  }

  // первые ставки
  int firstBlind(int bigBlindIndex) {
    logs.writeLog('First Blind');

    for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
      int localIndex =
          (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
      if (thisLobby.lobbyPlayers[localIndex].isActive) {
        if (thisLobby.lobbyPlayers[localIndex].bank <
            thisLobby.lobbySmallBlind) {
          thisLobby.lobbyPlayers[localIndex].bid =
              thisLobby.lobbyPlayers[localIndex].bank;
          thisLobby.lobbyPlayers[localIndex].bank = 0;
        } else {
          thisLobby.lobbyPlayers[localIndex].bank -= thisLobby.lobbySmallBlind;
          thisLobby.lobbyPlayers[localIndex].bid = thisLobby.lobbySmallBlind;
        }
        logs.writeLog('smallBlindIndex - $localIndex');
        //thisLobby.dealerIndex = (i+thisLobby.dealerIndex)%maxPlayerCount;
        break;
      }
    } // finding bigBlind
    for (int i = 1; i < thisLobby.lobbyPlayers.length + 1; i++) {
      int localIndex =
          (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
      if (thisLobby.lobbyPlayers[localIndex].isActive &&
          thisLobby.lobbyPlayers[localIndex].bid == 0) {
        if (thisLobby.lobbyPlayers[localIndex].bank <
            thisLobby.lobbySmallBlind * 2) {
          thisLobby.lobbyPlayers[localIndex].bid =
              thisLobby.lobbyPlayers[localIndex].bank;
          thisLobby.lobbyPlayers[localIndex].bank = 0;
        } else {
          thisLobby.lobbyPlayers[localIndex].bank -=
              thisLobby.lobbySmallBlind * 2;
          thisLobby.lobbyPlayers[localIndex].bid =
              thisLobby.lobbySmallBlind * 2;
        }
        bigBlindIndex = localIndex;
        logs.writeLog('bigBlindIndex - $localIndex');
        //thisLobby.dealerIndex = (i+thisLobby.dealerIndex)%maxPlayerCount;
        break;
      }
    }

    // finding start player
    for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
      int localIndex = (i + bigBlindIndex) % thisLobby.lobbyPlayers.length;
      if (thisLobby.lobbyPlayers[localIndex].isActive) {
        thisLobby.lobbyIndex = localIndex;
        thisLobby.firstPlayerIndex = localIndex;
        logs.writeLog('firstPlayerIndex - $localIndex');
        break;
      }
    }
    return bigBlindIndex;
  }
}
