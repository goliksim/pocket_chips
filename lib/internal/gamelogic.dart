//ОСНОВНАЯ ИГРОВАЯ ЛОГИКА
import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../pages/gamePage.dart';
import '../data/storage.dart';
import '../data/lobby.dart';
import '../ui/transitions.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';

late Game thisGame = Game();

class Game {
  Game({
    //переменная для кнопки +
    this.addButton = 0,
  });

  //переменная для кнопки +
  int addButton;
  
  //список названий этапов игры
  List<String> gameStateNameList = [
    "game.pflop".tr(),
    "game.flop".tr(),
    "game.turn".tr(),
    "game.river".tr(),
    "game.shdw".tr(),
    "game.break".tr()
  ];
  int raiseBank = 0;
  bool raiseButtonPressed = false;
  bool bidsEqual = false;
  Text gameStateName = Text("game.welc".tr(),
      style: TextStyle(color: thisTheme.primaryColor));
  Function()? callback;
  BuildContext? context;
  

  // меняем отступы у игроков
  void changeOffset() {
    Random rnd = Random();

    List<double> arr = [];
    for (int a = 0; a < maxPlayerCount; a++) {
      arr.add((rnd.nextInt(40) - 20) / 360 * 2 * pi);
    }
    arr[0] = 0.0;
    thisLobby.lobbyRandomOffset = arr;
    lobbyStorage.writeLobby(thisLobby);
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
      lobbyStorage.writeLobby(thisLobby);
      newPlayer(index: thisLobby.firstPlayerIndex);
      callback!();
      changeText(gameStateNameList[thisLobby.lobbyState]);
    } else {
      showToast('toast.moreplay'.tr());
    }
  }

  // переходы между игроками
  int newPlayer({int index = 100}) {
    //print(bigBlindIndex); 
    //
    if (index == 100) {
      thisLobby.lobbyIndex += 1;
      if (thisLobby.lobbyIndex == thisLobby.lobbyPlayers.length) {
        logs.writeLog("End of circle. Move to first in list");
        thisLobby.lobbyIndex = 0;
      }
    } else {
      thisLobby.lobbyIndex = index;
    }


    //print(thisLobby.lapCount);
    //print(thisGame.bidsEqual);
    //print(thisGame.waitForBidsEqual());

    if ((thisLobby.lobbyPlayers.map((e) => e.bank).where((element) => element != 0).isEmpty)) {
      logs.writeLog(
          'No one player with money\n${thisLobby.lobbyPlayers.map((e) => [e.name, e.bank
              ])}');
      newLap();
      return 0;
    }


    if(index==100){
      if(!bidsEqual&&waitForBidsEqual()){
        //bidsEqual = waitForBidsEqual();
        if(thisLobby.lapCount>0) newState();
      }
      else{
        if(thisLobby.lobbyIndex==thisLobby.firstPlayerIndex && thisLobby.lapCount>0 && waitForBidsEqual()) newState();
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
    logs.writeLog('Bids: ${thisLobby.lobbyPlayers.map((e) => [
          e.name,
          e.bid
        ].join(': ')).join('\t')}');

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
    thisGame.bidsEqual = thisGame.waitForBidsEqual();
    if (thisLobby.lobbyIndex == thisLobby.bigBlindIndex){
      thisLobby.lapCount+=1;
    }
    // print('raisebank');
    //print(raiseBank);
    if (index == 100) {
      gameStateName = Text(
          "game.turn1".tr()+"\u00A0"+"game.turn2".tr()+"\u00A0""${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}",
          style: TextStyle(color: thisTheme.onBackground));
    }
    callback!();
    logs.writeLog(
        "Turn of ${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}");
    lobbyStorage.writeLobby(thisLobby);
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

    int result = toEqual + [lastRaise, thisLobby.lobbySmallBlind * 2].max;
    //var result = [(toEqual + lastRaise + ((lastRaise+toEqual==0)?thisLobby.lobbySmallBlind*2:0) + ((lastRaise+toEqual==0 && thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank<thisLobby.lobbySmallBlind*2)?thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank:0)),
    //((thisLobby.lobbyState==0)?4:2)*thisLobby.lobbySmallBlind - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid].max;
    //print("minTmpFunction - $result");
    return result;
  }

  // временное изменение текста
  void changeText(String text) async {
    gameStateName = Text(text,
        style: TextStyle(
            color: thisTheme
                .primaryColor)); //если конец, то переходим в новый круг
    callback!();
    await Future.delayed(const Duration(seconds: 4));
    gameStateName = Text(
        "game.turn1".tr()+"\u00A0"+"game.turn2".tr()+"\u00A0""${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}",
        style: TextStyle(color: thisTheme.onBackground));

    callback!();
  }

  // новая улица
  void newState() async {
    //проверяем, шобы ставки были одинаковы
    if (waitForBidsEqual()) {
      //переходим в новое состояние
      thisLobby.lobbyState += 1;
      logs.writeLog("NewState with lobbyState = ${thisLobby.lobbyState}");
      lobbyStorage.writeLobby(thisLobby);
    }
    else{
    }
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
    bool allInBool = false;
    bool equalBool = false;
    //bool preFlop = false;
    for (Player player in thisLobby.lobbyPlayers) {
      equalBool = (player.isActive) &&
          (player.bid != thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max));
      allInBool = !((player.bid > 0) && (player.bank == 0));
      //preFlop = (player.isActive) && (player.bid == thisLobby.lobbySmallBlind*2);
      //if(!preFlop) return true;
      //pr(equalBool);
      if (equalBool && allInBool) {
        return false;
      }
    }
    if (thisLobby.lapCount==0) {
      return false;
    } else {
      return true;
    }
  }

  // новый круг
  Future newLap({bool folded = false}) async {
    thisLobby.lobbyState = 4;

    gameStateName =
        Text("Showdown", style: TextStyle(color: thisTheme.primaryColor));
    callback!();
    // ignore: await_only_futures
    if (!folded) {
      logs.writeLog("Call WinnerChooseWindow");
      await transitionDialog(
          barrierDismissible: false,
          duration: const Duration(milliseconds: 400),
          type: "Scale1",
          //barrierColor: null,
          context: context,
          child: WillPopScope(
              onWillPop: () async => false,
              child: WinnerChooseWindow(thisLobby: thisLobby)),
          builder: (BuildContext context) {
            return WinnerChooseWindow(thisLobby: thisLobby);
          });
    }
    logs.writeLog("NEW Lap\tlobby state = 5\t lobbyIndex=-1;");

    //стираем старые ставки и тех, кто фолданул
    for (Player player in thisLobby.lobbyPlayers) {
      player.isActive = false;
      player.bid = 0;
      player.isActive = !(player.bank <= 0);
    }
    logs.writeLog(
        "Still Active players: ${thisLobby.lobbyPlayers.where((e) => e.isActive == true).map((e) => [
              e.name,
              e.bid
            ]).join(' / ')}");

    // finding dealer
    for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
      int localIndex =
          (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
      if (thisLobby.lobbyPlayers[localIndex].isActive) {
        thisLobby.dealerIndex = localIndex;
        logs.writeLog('new dealer index: $localIndex');
        break;
      }
    } // finding smallBlind
    thisLobby.lobbyState = 5;
    //await Future.delayed(Duration(milliseconds: 1));
    //changeText(gameStateNameList[thisLobby.lobbyState]);
    gameStateName =
        Text("game.break".tr(), style: TextStyle(color: thisTheme.primaryColor));
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
    for (Player player in thisLobby.lobbyPlayers) {
      player.isActive = !(player.bank <= 0);
      //player.isActive = !(player.bank < thisLobby.lobbySmallBlind * 2);
      player.bid = 0;
    }
    bidsEqual = false;
    lobbyStorage.writeLobby(thisLobby);
  }

  // первые ставки
  int firstBlind(int bigBlindIndex) {
  logs.writeLog('First Blind');

  for (int i = 1; i < thisLobby.lobbyPlayers.length; i++) {
    int localIndex =
        (i + thisLobby.dealerIndex) % thisLobby.lobbyPlayers.length;
    if (thisLobby.lobbyPlayers[localIndex].isActive) {
      if (thisLobby.lobbyPlayers[localIndex].bank < thisLobby.lobbySmallBlind) {
        thisLobby.lobbyPlayers[localIndex].bid =
            thisLobby.lobbyPlayers[localIndex].bank;
        thisLobby.lobbyPlayers[localIndex].bank = 0;
      } else {
        thisLobby.lobbyPlayers[localIndex].bank -= thisLobby.lobbySmallBlind;
        thisLobby.lobbyPlayers[localIndex].bid = thisLobby.lobbySmallBlind;
      }
      logs.writeLog("smallBlindIndex - $localIndex");
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
          thisLobby.lobbyPlayers[localIndex].bid = thisLobby.lobbySmallBlind * 2;
        }
        bigBlindIndex = localIndex;
        logs.writeLog("bigBlindIndex - $localIndex");
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
        logs.writeLog("firstPlayerIndex - $localIndex");
        break;
      }
    }
    return bigBlindIndex;
  }
}
