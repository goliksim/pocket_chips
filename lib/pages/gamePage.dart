// ignore_for_file: file_names
import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../internal/gamelogic.dart';
import '../widgets/lobbySettings.dart';
import '../ui/ui_widgets.dart';
import '../data/storage.dart';
import '../data/lobby.dart';
import '../ui/transitions.dart';
import 'playersPage.dart';
import '../data/uiValues.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key})
      : super(key: key); // принимает значение title при обращении

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Random rnd = Random(); // для генерации отступа

  @override
  void initState() {
    super.initState();
    logs.writeLog(
        'Game was loaded with state: ${thisLobby.lobbyState}\t isActive: ${thisLobby.lobbyIsActive}');
    thisGame.addButton =
        (thisLobby.lobbyPlayers.length >= maxPlayerCount ? 0 : 1);
    

    // Действия только на старте
    if (!thisLobby.lobbyIsActive) {
      thisGame = Game(
          addButton: (thisLobby.lobbyPlayers.length >= maxPlayerCount ? 0 : 1));
      //инициализация начального положения дилера
      thisLobby.elementsOffset =
          thisLobby.lobbyPlayers.length ~/ 2 - thisLobby.dealerIndex;
      thisGame.startGame();
      if (thisLobby.lobbyRandomOffset.isEmpty) {
        thisGame.changeOffset();
      }
      setState(() {});
    }
    //Действия при возвращении
    else {
      if (thisLobby.lobbyIndex>=0 && thisLobby.lobbyIndex<4) {
        thisGame. gameStateName = Text(
          "game.turn1".tr()+"\u00A0"+"game.turn2".tr()+"\u00A0""${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}",
          style: TextStyle(color: thisTheme.onBackground));
      }
      //а вдруг крашнулось на выборе, тогда снова выведем окно
      Future.delayed(const Duration(milliseconds: 800), () {
        if (thisLobby.lobbyState == 4) thisGame.newLap();
      });
    }
    //восстановление после выхода или перезапуска 
    thisGame.context = context;
    thisGame.callback = () => setState(() {});
    thisGame.raiseButtonPressed = false;
    thisGame.bidsEqual = thisGame.waitForBidsEqual();
    //повторная проверка, а вдруг сделали закуп
    if (thisLobby.lobbyState == 5) {
      for (Player player in thisLobby.lobbyPlayers) {
        player.isActive = !(player.bank <= 0);
        //player.isActive = !(player.bank < thisLobby.lobbySmallBlind * 2);
      }
    }
  }

  void changeRaiseButton(int newBank) {
    setState(() {
      thisGame.raiseBank = newBank;
    });
  }

  void callback() {
    thisGame.addButton =
        (thisLobby.lobbyPlayers.length >= maxPlayerCount ? 0 : 1);
    setState(() {});
    lobbyStorage.writeLobby(thisLobby);
  }

  @override
  Widget build(BuildContext context) {
    double tableButtonWidth =MediaQuery.of(context).size.width - adaptiveOffset
    ;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: thisTheme.bgrColor,
            child:PatternContainer(
              opacity: 0.5,
              padding: EdgeInsets.only(top: stdCutoutWidth*0.75,bottom: stdCutoutWidthDown*0.75),
 
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: stdButtonHeight * 0.75,
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  size: stdIconSize,
                ),
              )
            : null,
        iconTheme: IconThemeData(
          color: thisTheme.onBackground, //change your color here
        ),
        titleTextStyle: appBarStyle().copyWith(fontSize: stdFontSize / 20 * 22),
        elevation: 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              child: child,
              opacity: animation,
            );
          },
          child: Text(
            thisGame.gameStateName.data.toString(),
            key: ValueKey<String>(thisGame.gameStateName.data.toString()),
            style: thisGame.gameStateName.style,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0x00000000),
        actions: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: (thisLobby.lobbyState == 5)
                ? Transform.scale(
                    scaleX: -1,
                    child: IconButton(
                      icon: Icon(
                        Icons.sync_sharp, //Icons.info_outline,
                        color: thisTheme.onBackground,
                        size: stdIconSize,
                      ),
                      tooltip: 'tooltip.rot'.tr(),
                      onPressed: () {
                        thisLobby.mixPlayersPosition();
                        thisGame.changeOffset();
                        callback();
                      },
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                  bottom: adaptiveOffset,
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Buttons
                  Expanded(
                    child: Align(
                    alignment: Alignment.topCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        fit : StackFit.expand,
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: SizedBox(
                                height: 7.3 * stdButtonHeight,
                                child: Stack(
                                  fit : StackFit.expand,
                                  alignment: Alignment.center,
                                  children: [
                                    //Table
                                    Container(
                                        //duration: Duration(milliseconds: 500),
                                        margin: EdgeInsets.only(
                                            top: stdButtonHeight / 3,
                                            bottom: stdButtonHeight / 3),
                                        //height: 550,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                                thisTheme.primaryColor.withOpacity(
                                                    thisTheme.name == 'light'
                                                        ? 0.075
                                                        : 0),
                                                BlendMode.srcATop),
                                            fit: BoxFit.contain,
                                            image: AssetImage(
                                                'assets/table_${thisTheme.name}.png'),
                                          ),
                                        )),
                                    // 3 карты по середине
                                    Positioned(
                                      child: cards2(0),
                                      bottom: 3 * stdButtonHeight,
                                    ),
                                    // 2 карты по середине
                                    Positioned(
                                      child: cards2(1),
                                      bottom: 2.2 * stdButtonHeight,
                                    ),
                                    Positioned(
                                      child: Text(
                                          '${thisLobby.lobbySmallBlind} / ${thisLobby.lobbySmallBlind * 2}',
                                          style: TextStyle(
                                              color: thisTheme.onBackground
                                                  .withOpacity(0.2),
                                              fontSize: stdFontSize * 0.6)),
                                      bottom: 2.5 * stdButtonHeight,
                                    ),
                                    // Общая ставка
                                    Positioned(
                                      child: FittedBox(
                                          child: Container(
                                        height: stdHeight / 2.5,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: stdHorizontalOffset / 2),
                                        decoration: BoxDecoration(
                                          color: thisTheme.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(stdBorderRadius),
                                        ),
                                        child: Center(
                                          child: Text(
                                              "\$ ${thisLobby.lobbyPlayers.map((e) => e.bid).sum}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: stdFontSize * 0.75)),
                                        ),
                                      )),
                                      bottom: 2.175 * stdButtonHeight,
                                    ),
                                    // Карточки игроков
                                    for (int a = 0; a < thisLobby.lobbyPlayers.length + thisGame.addButton; a++)
                                      Positioned(
                                          bottom: 3.4 * stdButtonHeight -
                                              3.2 * stdButtonHeight * getCos(a),
                                          left: tableButtonWidth / 2 - (stdButtonHeight*1.25 * getSin(a, multiply: -0.5) + stdButtonHeight * 0.65 * (1 + sin(a * 2 * pi / (thisLobby.lobbyPlayers.length + thisGame.addButton)))),
                                          child: ((a == 0) &&
                                                  (thisGame.addButton > 0))
                                              ? AddBottom(
                                                  callBackFunction: callback,
                                                )
                                              : playerCard((a - thisGame.addButton - thisLobby.elementsOffset)%thisLobby.lobbyPlayers.length, a - thisGame.addButton) // playerCard(a - thisGame.addButton) - без крутежки игроков
                                          ),
                                    // Ставки игроков
                                    for (int a = thisGame.addButton; a < thisLobby.lobbyPlayers.length + thisGame.addButton; a++)
                                      Positioned(
                                          bottom:
                                              -3.18 * stdButtonHeight * getCos(a) + 3.61 * stdButtonHeight - (getCos(a) > 0.01? -stdButtonHeight * 0.5 : stdButtonHeight * 0.5),
                                          left: adaptiveOffset + (tableButtonWidth) / 2 - stdButtonHeight / 2.1 - (stdButtonHeight*1.25 * getSin(a, multiply: -1) + stdButtonHeight * 0.7 * 0.75 / 2 * (1 + sin(a * 2 * pi / (thisLobby.lobbyPlayers.length + thisGame.addButton)))),
                                          child: (thisLobby.lobbyPlayers[(a - thisGame.addButton - thisLobby.elementsOffset)%thisLobby.lobbyPlayers.length].bid !=0)
                                              ? chip((a - thisGame.addButton - thisLobby.elementsOffset) % thisLobby.lobbyPlayers.length) //chip((a - thisGame.addButton) - без крутежки игроков
                                              : const SizedBox()),
                                    
                                  ],
                                )),
                          ),
                          Positioned(
                                      bottom: stdHorizontalOffset,
                                      child: 
                                      Container(
                                        alignment: Alignment.center,
                                        width: [stdButtonWidth, MediaQuery.of(context).size.width - stdHorizontalOffset*2].min,
                                        height: stdButtonHeight*1.6,
                                        child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 500),
                                            child: !thisGame.raiseButtonPressed
                                                ? SizedBox(
                                                    height: 2 * stdButtonHeight * 0.75 +
                                                        stdHorizontalOffset / 2,
                                                  )
                                                : StaticRaiseButton(
                                                    changeButtonBool: raiseAction,
                                                    newPlayer: thisGame.newPlayer,
                                                    changeRaiseButton: changeRaiseButton,
                                                    raiseBank: thisGame.raiseBank),
                                          ),
                                        
                                      ),
                                    ),
                          ],
                      ),
                    ),
                  ),

                  
                  // Панелька кнопок
                  Container(
                      width: [stdButtonWidth, MediaQuery.of(context).size.width - stdHorizontalOffset*2].min,
                      child: (thisLobby.lobbyState != 5)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Кнопка Raise
                                controlButton(firstButtonString(),
                                    thisTheme.primaryColor, raiseAction,
                                    condition: raiseButtonActiveBool()),
                                // Кнопка подтверждения Raise/Bet
                                thisGame.raiseButtonPressed
                                    ? controlButton(raiseBetString(),
                                        thisTheme.secondaryColor, confirmRaiseBet)
                                    : controlButton(
                                        middleButtonString(),
                                        thisTheme.secondaryColor,
                                        universalAction), // Кнопка Call/Check/Skip
                                // Кнопка Fold
                                controlButton("game.fold".tr(),
                                    thisTheme.additionButtonColor, foldAction),
                              ],
                            )
                          : Row(
                              children: [
                                MyButton(
                                  height: stdButtonHeight,
                                  width: stdButtonHeight,
                                  buttonColor: thisTheme.additionButtonColor,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Icon(
                                      Icons.settings,
                                      color: thisTheme.onPrimary,
                                      size: stdIconSize,
                                      //size: stdIconSize,
                                    ),
                                  ),
                                  action: () async {
                                    await transitionDialog(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        type: "SlideDown",
                                        context: context,
                                        child: AddSettings(
                                          thisLobby: thisLobby,
                                          bankUpdate: bankUpdate,
                                        ),
                                        builder: (BuildContext context) {
                                          return AddSettings(
                                              thisLobby: thisLobby,
                                              bankUpdate: bankUpdate);
                                        });
                                    callback();
                                    SystemChrome.restoreSystemUIOverlays();
                                  },
                                ),
                                SizedBox(width: stdHorizontalOffset),
                                Expanded(
                                  child: MyButton(
                                    height: stdButtonHeight,
                                    width: double.infinity,
                                    buttonColor: thisTheme.primaryColor.withOpacity((thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1) ? 1: 0.3),
                                    textStyle: stdTextStyle.copyWith(
                                        fontSize: stdFontSize,
                                        color: thisTheme.onPrimary.withOpacity(
                                            (thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1) ? 1 : 0.3)),
                                    textString: "game.start".tr(),
                                    action: () => thisGame.startBetting(),
                                  ),
                                ),
                              ],
                            ))
                ],
              )),
      ),
      ),
      ),
    );
  }

  double getCos(a) {
    double offset = thisLobby.lobbyRandomOffset[a] / thisLobby.lobbyPlayers.length;
    return cos(2 * pi * (a / (thisLobby.lobbyPlayers.length + thisGame.addButton)) + offset) * pow( (cos(2 * pi * (a / (thisLobby.lobbyPlayers.length + thisGame.addButton)) + offset)).abs(), 0.3);
  }

  double getSin(a, {multiply = 0}) {
    double offset = 0; // thisLobby.lobbyRandomOffset[a]/thisLobby.lobbyPlayers.length*2;
    return sin(2 *pi * (a / (thisLobby.lobbyPlayers.length + thisGame.addButton)) + offset) *  pow( sin(2 * pi * (a /(thisLobby.lobbyPlayers.length + thisGame.addButton)) + 0.01 + offset).abs(),multiply);
  }

  //Текст средней кнопки
  String middleButtonString() {
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid ==
        thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max)) {
      return "game.check".tr();
    } else {
      return (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank +
                  thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid >
              thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max))
          ? "game.call".tr()+" \$${(thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max) - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid)}"
          : "game.all".tr();
    }
  }

  //Текст кнопки подтверждения
  String raiseBetString() {
    if (thisGame.raiseBank ==
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank) {
      return 'game.all'.tr();
    } else {
      return ((thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid ==
                      thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max) &&
                  thisLobby.lobbyState != 0)
              ? "game.bet".tr()
              : "game.raise".tr()) +
          " \$${thisGame.raiseBank}";
    }
  }

  //Текст первой кнопки
  String firstButtonString() {
    if (!thisGame.raiseButtonPressed) {
      int allMoney = thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank +
          thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid;
      if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid ==
              thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max) &&
          thisLobby.lobbyState != 0) {
        return "game.bet".tr();
      } else {
        //print(raiseBank);
        return (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank <=
                    thisGame.raiseBank &&
                allMoney > thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max))
            ? 'game.all'.tr()
            : "game.raise".tr();
      }
    } else {
      return "game.raise.canc".tr();
    }
  }

  // Карты в два ряда
  Widget cards2(int count) => SizedBox(
        height: stdButtonHeight * 0.75 * 2 * 0.85,
        width: stdButtonHeight * 0.75 * (3 - count) * 0.75,
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            childAspectRatio: 0.7,
            crossAxisCount: 3 - count,
          ),
          itemCount: 3 - count,
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              duration: Duration(milliseconds: 500 + (index + 3 * count) * 100),
              transitionBuilder: (Widget widget, Animation<double> animation) {
                final rotateAnim =
                    Tween(begin: pi, end: 0.0).animate(animation);
                return AnimatedBuilder(
                  animation: rotateAnim,
                  child: widget,
                  builder: (context, widget) {
                    final isUnder = (const ValueKey("1") != widget?.key);
                    var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                    tilt *= isUnder ? -1.0 : 1.0;
                    final value = min(rotateAnim.value, pi / 2);
                    return Transform(
                      transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                      child: widget,
                      alignment: Alignment.center,
                    );
                  },
                );
              },
              child: (index + 3 * count >=
                      thisLobby.lobbyState % 5 +
                          (thisLobby.lobbyState % 5 > 0 ? 2 : 0))
                  ? Container(
                      key: const Key("1"),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: thisTheme.bankColor.withOpacity(1)),
                        borderRadius:
                            BorderRadius.circular(0.35 * stdBorderRadius),
                        image: DecorationImage(
                          colorFilter: (thisTheme.name == 'dark')
                              ? ColorFilter.mode(
                                  thisTheme.primaryColor.withOpacity(0.2),
                                  BlendMode.srcATop)
                              : ColorFilter.mode(
                                  thisTheme.primaryColor.withOpacity(0.8),
                                  BlendMode.colorDodge),
                          fit: BoxFit.cover,
                          image: AssetImage((thisTheme.name == 'dark')
                              ? 'assets/сard_back_dark.jpg'
                              : 'assets/сard_back.jpg'),
                        ),
                      ),
                    )
                  : Container(
                      key: const Key("2"),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1,
                            color: thisTheme.bankColor.withOpacity(1)),
                        borderRadius:
                            BorderRadius.circular(0.35 * stdBorderRadius),
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              thisTheme.primaryColor.withOpacity(0.04),
                              BlendMode.srcATop),
                          fit: BoxFit.cover,
                          image: AssetImage((thisTheme.name == 'dark')
                              ? 'assets/card_front_dark.jpg'
                              : 'assets/card_front.jpg'),
                        ),
                      ),
                    ),
            );
          },
        ),
      );
  // Окно игрока
  Widget playerCard(int a, int index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        //padding: EdgeInsets.symmetric(horizontal: stdHeight*0.1),
        height: stdHeight,
        width: stdHeight * 2.2,

        child: MyButton(
          borderRadius: BorderRadius.circular(stdBorderRadius * 2),
          height: stdHeight,
          buttonColor: (a == thisLobby.lobbyIndex)
              ? thisTheme.primaryColor
              : thisTheme.bankColor
                  .withOpacity(thisLobby.lobbyPlayers[a].isActive ? 1 : 0.5),
          longAction: () async {
            await transitionDialog(
              duration: const Duration(milliseconds: 400),
              type: "Scale1",
              //barrierColor: null,
              context: context,
              child: AddWindow(
                  player: thisLobby.lobbyPlayers[a],
                  callBackFunction: callback,
                  playerIndex: a,
                  settingsBool: (thisLobby.lobbyState == 5)),
              builder: (BuildContext context) {
                return AddWindow(
                    player: thisLobby.lobbyPlayers[a],
                    callBackFunction: callback,
                    playerIndex: a,
                    settingsBool: (thisLobby.lobbyState == 5));
              },
            );
            SystemChrome.restoreSystemUIOverlays();
            thisGame. gameStateName = Text(
                "game.turn1".tr()+"\u00A0"+"game.turn2".tr()+"\u00A0""${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}",
                style: TextStyle(color: thisTheme.onBackground));
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: sin(2 *
                          pi *
                          (index /
                              (thisLobby.lobbyPlayers.length -
                                  thisGame.addButton))) <
                      0
                  ? reversablePlayerWidgetList(a)
                  : List.from(reversablePlayerWidgetList(a).reversed)),
        ),
      );
  // В зависимости от значения, возвращает либо лого перtсонажа, либо имя с банком
  List<Widget> reversablePlayerWidgetList(int index) {
    return [
      Stack(
        children: [
          Container(
            width: stdHeight,
            height: stdHeight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(
                    thisLobby.lobbyPlayers[index].assetUrl,
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(
                        thisLobby.lobbyPlayers[index].isActive ? 1 : 0.2),
                    BlendMode.modulate,
                  ),
                  fit: BoxFit.fill),
            ),
          ),
          thisLobby.dealerIndex == index
              ? Container(
                  width: stdHeight,
                  height: stdHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: const AssetImage(
                          'assets/chips/dealer.png',
                        ),
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(
                              thisLobby.lobbyPlayers[index].isActive ? 1 : 0.2),
                          BlendMode.modulate,
                        ),
                        fit: BoxFit.fill),
                  ),
                )
              : Container(),
        ],
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  thisLobby.lobbyPlayers[index].name,
                  style: TextStyle(
                      color: (index == thisLobby.lobbyIndex)
                          ? thisTheme.onPrimary
                          : thisTheme.onBackground.withOpacity(
                              thisLobby.lobbyPlayers[index].isActive ? 1 : 0.2),
                      fontWeight: FontWeight.bold,
                      fontSize:  stdFontSize),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    "${thisLobby.lobbyPlayers[index].bank}",
                    style: TextStyle(
                      fontSize:  stdFontSize*0.75,
                        color: (index == thisLobby.lobbyIndex)
                            ? thisTheme.onPrimary
                            : thisTheme.onBackground.withOpacity(
                                thisLobby.lobbyPlayers[index].isActive
                                    ? 1
                                    : 0.2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: stdHorizontalOffset / 2)
    ];
  }

  // Ставочки игроков
  Widget chip(int a) => FittedBox(
          child: Container(
        width: stdHeight * 2,
        alignment: Alignment.center,
        child: Container(
          height: stdHeight / 2.5,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: thisTheme.playerColor,
            borderRadius: BorderRadius.circular(stdBorderRadius),
          ),
          child: Text("\$ ${thisLobby.lobbyPlayers[a].bid}",
              style: TextStyle(
                  color: thisTheme.onBackground.withOpacity(0.6),
                  fontSize: stdFontSize * 0.75)),
        ),
      ));

  Widget controlButton(String name, Color color, Function action, {bool condition = true}) => Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 4),
            child: MyButton(
                height: stdButtonHeight,
                width: double.infinity,
                buttonColor: color.withOpacity((condition) ? 1 : 0.3),
                textString: name,
                action: (condition) ? action : () => DoNothingAction),
        ),
      );

  // Реализация средней кнопки
  void universalAction() {
    
    var maxBid = thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max);

    //Обычное действие Check/Call/All In
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid == maxBid) {
      thisGame.newPlayer();
    } else {
      // CALL

      if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank +
              thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid >
          maxBid) {
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank -=
            (maxBid - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid);
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid = maxBid;

        //print(thisLobby.lapCount);
        //print(thisGame.bidsEqual);
        //print(thisGame.waitForBidsEqual());

        if(!thisGame.bidsEqual&&thisGame.waitForBidsEqual()&&thisLobby.lapCount!=0){
          thisGame.bidsEqual = thisGame.waitForBidsEqual();
          thisGame.newState();
        }
        else {
          thisGame.newPlayer();
        } 
        
      } else {
        // ALL IN
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid +=
            thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank;
        thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank = 0;

        //print(thisLobby.lapCount);
        //print(thisGame.bidsEqual);
        //print(thisGame.waitForBidsEqual());

        if(!thisGame.bidsEqual&&thisGame.waitForBidsEqual()&&thisLobby.lapCount!=0){
          //print('xcvnbxcmbvncx');
          thisGame.bidsEqual = thisGame.waitForBidsEqual();
          thisGame.newState();
        }
        else {
          thisGame.newPlayer();
        } 
      }
    }
  }

  //Выполняет функцию рейза в количестве raiseBank
  void confirmRaiseBet() {
    thisGame.raiseButtonPressed = false;
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank -= thisGame.raiseBank;
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid += thisGame.raiseBank;
    thisGame.newPlayer();
  }


  // Реализация кнопки Raise
  void raiseAction() {
    if (!thisGame.raiseButtonPressed) {
      thisGame.raiseBank = thisGame.minTmpFunction(thisGame.bidsEqual);
    }
    //Если денег хватает на рейз -> выводим окошко
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank >= 
        thisGame.raiseBank) {
      thisGame.raiseButtonPressed = !thisGame.raiseButtonPressed;
    } else {
      //if(thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank+thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid>thisLobby.lobbyPlayers.map((e) => e.bid).reduce(max)){
      thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid +=
          thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank;
      thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank = 0;
      thisGame.newPlayer();
      thisGame.raiseButtonPressed = !thisGame.raiseButtonPressed;
      //}
    }
    setState(() {});
  }

  // Реализация кнопки Fold
  void foldAction() async {
    logs.writeLog(
        'Fold of ${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name} with index ${thisLobby.lobbyIndex}');
    thisLobby.lobbyPlayers[thisLobby.lobbyIndex].isActive = false;
    if (thisLobby.lobbyPlayers.where((e) => e.isActive == true).length > 1) {
      setState(() {});
      thisGame.raiseButtonPressed = false;
      thisGame.newPlayer();
    } else {
      late BuildContext dialogContext;
      showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 500),
        context: context,
        pageBuilder: (context, a1, a2) {
          dialogContext = context;
          return WinnerWindow(
              winner: thisLobby.lobbyPlayers[thisLobby.lobbyPlayers
                  .indexWhere((e) => e.isActive == true)]);
        },
        transitionBuilder: getTransition("Scale1"),
      );
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(dialogContext);
      thisLobby
          .lobbyPlayers[
              thisLobby.lobbyPlayers.indexWhere((e) => e.isActive == true)]
          .bank += thisLobby.lobbyPlayers.map((e) => e.bid).sum;
      thisGame.newLap(folded: true);
      setState(() {});
    }
  }

  bool raiseButtonActiveBool() => (thisLobby
              .lobbyPlayers[thisLobby.lobbyIndex].bank +
          thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid >
      thisLobby.lobbyPlayers.map((e) => e.bid).reduce(
          max)); //&&(thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank >= minTmpFunction()))),

}

class WinnerWindow extends StatefulWidget {
  const WinnerWindow({Key? key, required this.winner}) : super(key: key);

  final Player winner;
  @override
  State<WinnerWindow> createState() => _WinnerWindowState();
}

class _WinnerWindowState extends State<WinnerWindow> {
  String bgrText = '';

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      bgrText += 'game.win1'.tr()+'\u00A0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          horizontal: [
        (MediaQuery.of(context).size.width - stdButtonHeight * 4) / 2,
        adaptiveOffset
      ].max),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: SizedBox(
        height: stdButtonHeight * 4,
        width: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  padding: EdgeInsets.only(left: stdHorizontalOffset / 4),
                  height: stdButtonHeight * 3,
                  width: stdButtonHeight * 4,
                  child: Text(bgrText,
                      overflow: TextOverflow.fade,
                      maxLines: 20,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Ubuntu",
                          color: thisTheme.bankColor.withOpacity(0.5),
                          fontWeight: FontWeight.w700,
                          fontSize: stdFontSize * 2)),
                ),
                Positioned(
                  top: stdButtonHeight / 8,
                  child: Container(
                    height: stdButtonHeight * 3,
                    width: stdButtonHeight * 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(
                            widget.winner.assetUrl,
                          ),
                          fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: stdButtonHeight,
                    width: stdButtonHeight * 4,
                    alignment: Alignment.center,
                    child: Text(
                        "${thisLobby.lobbyPlayers[thisLobby.lobbyPlayers.indexWhere((e) => e.isActive == true)].name} "+"game.win2".tr(),
                        style: TextStyle(
                            color: thisTheme.primaryColor,
                            fontSize: stdFontSize,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

// Static Raise Window
class StaticRaiseButton extends StatefulWidget {
  const StaticRaiseButton(
      {Key? key,
      required this.changeButtonBool,
      required this.newPlayer,
      required this.changeRaiseButton,
      required this.raiseBank})
      : super(key: key);
  final Function changeButtonBool;
  final Function newPlayer;
  final Function changeRaiseButton;
  final int raiseBank;

  @override
  _StaticRaiseButtonState createState() => _StaticRaiseButtonState();
}

class _StaticRaiseButtonState extends State<StaticRaiseButton> {
  late int tmpBid;
  late int mintmpBid;

  @override
  void initState() {
    super.initState();
    mintmpBid = widget.raiseBank;
    tmpBid = mintmpBid;
    Future.delayed(const Duration(milliseconds: 0), () {
      widget.changeRaiseButton(tmpBid);
    });
  }

  List<int> chips(int maxbank) {
    List<int> tmplist = [1, 5, 10, 25, 50, 100, 500, 1000, 5000, 10000];
    while (true) {
      if (tmplist.last > maxbank) {
        tmplist.removeLast();
        continue;
      }
      return tmplist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(stdBorderRadius),
      child: Container(
        color: thisTheme.playerColor,
        child: Column(
          children: [
            SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(stdButtonHeight * 0.75),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,

                  //padding: const EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
                  //height: stdHeight ,

                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // <-- notice 'min' here. Important
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int a in chips(
                          thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank -
                              mintmpBid))
                        Container(
                          width: stdButtonHeight * 0.75,
                          height: stdButtonHeight * 0.75,
                          margin: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2.5),
                          //padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: thisTheme.playerColor,
                            borderRadius:
                                BorderRadius.circular(stdBorderRadius),
                          ),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          stdBorderRadius))),
                              child: Image.asset("assets/chips/chips_$a.png"),
                              onPressed: () {
                                if (tmpBid + a <=
                                    thisLobby.lobbyPlayers[thisLobby.lobbyIndex]
                                        .bank) {
                                  tmpBid += a;
                                  widget.changeRaiseButton(tmpBid);
                                }
                                setState(() {});
                              }),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset),
              height: stdButtonHeight * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$mintmpBid",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: stdFontSize, color: thisTheme.onBackground),
                  ),
                  SizedBox(width: stdHorizontalOffset / 2),
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Slider(
                      label: "$widget.tmpBid",
                      value: tmpBid.toDouble(),
                      onChanged: (newValue) {
                        //thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank+=thisLobby.bids[thisLobby.lobbyIndex];
                        tmpBid = newValue.toInt();
                        widget.changeRaiseButton(tmpBid);
                        setState(() {});
                      },
                      min: mintmpBid.toDouble(),
                      max: thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank
                          .toDouble(),
                    ),
                  ),
                  SizedBox(width: stdHorizontalOffset / 2),
                  Text(
                    "${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: stdFontSize, color: thisTheme.onBackground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerChooseWindow extends StatefulWidget {
  WinnerChooseWindow(
      {Key? key, required this.thisLobby, this.title = ''})
      : super(key: key); // принимает значение title при обращении
  final Lobby thisLobby;
  String title;
  @override
  State<WinnerChooseWindow> createState() => _WinnerChooseWindowState();
}

class _WinnerChooseWindowState extends State<WinnerChooseWindow> {
  List<int> maybewinners = [];
  List<bool> winners = [];

  @override
  void initState() {
    super.initState();
    widget.title = 'game.win3'.tr();
    logs.writeLog("${widget.title} window");
    for (int i = 0; i < thisLobby.lobbyPlayers.length; i++) {
      if (thisLobby.lobbyPlayers[i].isActive) {
        maybewinners.add(i);
      }
      winners.add(false);
    }
    logs.writeLog(
        "Still Active players: ${thisLobby.lobbyPlayers.where((e) => e.isActive == true).map((e) => [
              e.name,
              e.bid
            ]).join(' / ')}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
          //vertical: stdHorizontalOffset,
          horizontal:
              adaptiveOffset), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: (stdButtonHeight * 0.75 + stdHorizontalOffset / 2) *
                (((maybewinners.length > standartPlayerCount)
                    ? standartPlayerCount
                    : maybewinners.length)) +
            stdButtonHeight * 1.5 +
            stdHorizontalOffset,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: stdButtonHeight * 0.5,
                child: Center(
                  child: Text(widget.title,
                      style: TextStyle(
                          color: thisTheme.onBackground,
                          fontSize: stdFontSize)),
                ),
              ),
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          for (int i in maybewinners)
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: stdHorizontalOffset / 2),
                                child: MyButton(
                                    height: stdButtonHeight * 0.75 +
                                        stdHorizontalOffset / 2,
                                    buttonColor: thisTheme.bankColor,
                                    action: () {
                                      winners[i] = !winners[i];
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: stdHorizontalOffset),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: stdButtonHeight * 0.75 * 0.8,
                                            height:
                                                stdButtonHeight * 0.75 * 0.8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    thisLobby.lobbyPlayers[i]
                                                        .assetUrl,
                                                  ),
                                                  fit: BoxFit.fitHeight),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      thisLobby
                                                          .lobbyPlayers[i].name,
                                                      style: TextStyle(
                                                          color: thisTheme
                                                              .onBackground,
                                                          fontSize:
                                                              stdFontSize *
                                                                  0.75)),
                                                  Text(
                                                      "game.bet".tr()+": ${thisLobby.lobbyPlayers[i].bid}",
                                                      style: TextStyle(
                                                          color: thisTheme
                                                              .onBackground,
                                                          fontSize:
                                                              stdFontSize *
                                                                  0.75)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Checkbox(
                                              activeColor:
                                                  thisTheme.primaryColor,
                                              value: winners[i],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  winners[i] = value!;
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ))),
                        ],
                      )),
                ),
              ),
              SizedBox(height: stdHorizontalOffset),
              MyButton(
                  height: stdButtonHeight * 0.75 * 0.75,
                  width: double.infinity,
                  buttonColor: thisTheme.primaryColor,
                  textString: "game.win.conf".tr(),
                  action: () {
                    if (winners.where((e) => e == true).isNotEmpty) {
                      moneyDistribution(winners, context);
                    } else {
                      showToast("toast.winn".tr());
                    }
                  })
            ]),
      ),
    );
  }

  Future moneyDistribution(List<bool> winners, BuildContext context) async {
    int deletedWinners = 0;
    //множество ставок
    List<int> bids = thisLobby.lobbyPlayers.map((e) => e.bid).toSet().toList();
    bids.sort();
    if (bids[0] == 0) bids.removeAt(0);
    //проходимся по каждому разному значения ставок
    logs.writeLog("Bids - $bids");

    for (int k = 0; k < bids.length; k++) {
      int bid = bids[k];
      if (bid <= 0) continue;

      logs.writeLog("Winners - $winners");
      //pr("New cycle");
      if ((winners.where((e) => e == true).isEmpty) &&
          (thisLobby.lobbyPlayers.where((e) => e.isActive == true).length >
              1)) {
        //pr("Window");

        await transitionDialog(
            barrierDismissible: false,
            duration: const Duration(milliseconds: 400),
            type: "Scale1",
            context: context,
            child: WinnerChooseWindow(
              thisLobby: thisLobby,
              title: "game.win4".tr(),
            ),
            builder: (BuildContext context) {
              return WinnerChooseWindow(
                thisLobby: thisLobby,
                title: "game.win4".tr(),
              );
            });

        Navigator.pop(context);
        return 0;
      }

      //pr("Bid - $bid");
      // та сумма которая будет распределяться по победителям для данной ставки
      int tmpSum = 0;
      //проходимся по ставкам
      for (int i = 0; i < thisLobby.lobbyPlayers.length; i++) {
        //проверяем, ставил ли кто-то из победителей и не из победителей данную ставку
        //если челик такую ставку поставил
        if (thisLobby.lobbyPlayers[i].bid >= bid) {
          //если не победитель, то вносим ее в общий банк
          if (!winners[i]) {
            tmpSum += bid;
          } else {
            thisLobby.lobbyPlayers[i].bank += bid;
          }
        }
      }

      //pr("Сумма для дележки $tmpSum");
      //разделенная добыча делится на победителей, причем тока тех, кто еще в игре
      logs.writeLog("Devide on ${winners.where((e) => e == true).length}");

      //заканчиваем цикл если остаток остался, а челиксы закончились
      if (winners.where((e) => e == true).isEmpty) {
        Navigator.pop(context);
        for (int i = 0; i < winners.length; i++) {
          thisLobby.lobbyPlayers[i].bank += (thisLobby.lobbyPlayers[i].bid > 0)
              ? thisLobby.lobbyPlayers[i].bid
              : 0;
        }
        return 0;
      }

      for (int i = 0; i < winners.length; i++) {
        if ((winners[i]) && (thisLobby.lobbyPlayers[i].bid > 0)) {
          thisLobby.lobbyPlayers[i].bank +=
              tmpSum ~/ (winners.where((e) => e == true).length);
          logs.writeLog(
              "For ${thisLobby.lobbyPlayers[i].name} - ${thisLobby.lobbyPlayers[i].bank}");
        }
      }
      for (int m = 0; m < bids.length; m++) {
        bids[m] -= bid;
      }
      logs.writeLog("Bids - $bids");

      for (int i = 0; i < winners.length; i++) {
        if (thisLobby.lobbyPlayers[i].bid == bid) {
          winners[i] = false;
          thisLobby.lobbyPlayers[i].isActive = false;
        }
        thisLobby.lobbyPlayers[i].bid -= bid;
      }
    }

    Navigator.pop(context);
    return deletedWinners;
  }
}

// Кпопка добавления игрока
class AddBottom extends StatefulWidget {
  const AddBottom({Key? key, required this.callBackFunction}) : super(key: key);

  final Function() callBackFunction;
  @override
  State<AddBottom> createState() => _AddBottomState();
}

class _AddBottomState extends State<AddBottom> {
  bool addButtonPressed = false;
  @override
  Widget build(BuildContext context) {
    return thisLobby.lobbyState == 5
        ? SizedBox(
            height: stdButtonHeight * 0.75 * 0.8,
            width: stdButtonHeight * 0.75 * 2,
            child: Center(
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeInOutBack,
                switchOutCurve: Curves.easeInOutBack,
                duration: const Duration(milliseconds: 200),
                transitionBuilder:
                    (Widget widget, Animation<double> animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    child: widget,
                    builder: (context, widget) {
                      return Transform(
                          transform: Matrix4.diagonal3Values(
                              animation.value, 1.0, 1.0),
                          child: widget,
                          alignment: Alignment.center);
                    },
                  );
                },
                child: !addButtonPressed
                    ? Container(
                        key: const ValueKey("1"),
                        height: stdButtonHeight * 0.75 * 0.8,
                        width: stdButtonHeight * 0.75 * 0.8,
                        decoration: BoxDecoration(
                          color: thisTheme.primaryColor,
                          borderRadius:
                              BorderRadius.circular(stdBorderRadius * 2),
                        ),
                        child: FittedBox(
                          child: IconButton(
                            tooltip: 'tooltip.add.main'.tr(),
                            splashRadius: stdButtonHeight * 0.75 * 0.45,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              //size: stdIconSize,
                            ),
                            onPressed: () async {
                              setState(() {
                                addButtonPressed = true;
                              });
                              await Future.delayed(const Duration(seconds: 10));
                              setState(() {
                                addButtonPressed = false;
                              });
                            },
                          ),
                        ),
                      )
                    : Row(
                        key: const ValueKey("2"),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                              height: stdButtonHeight * 0.75 * 0.8,
                              width: stdButtonHeight * 0.75 * 0.8,
                              decoration: BoxDecoration(
                                color: thisTheme.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(stdBorderRadius * 2),
                                    topLeft:
                                        Radius.circular(stdBorderRadius * 2)),
                              ),
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: IconButton(
                                  splashRadius: stdButtonHeight * 0.75 * 0.45,
                                  icon: const Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                    //size: stdIconSize,
                                  ),
                                  tooltip: 'tooltip.add.new'.tr(),
                                  onPressed: () async {
                                    setState(() {
                                      addButtonPressed = false;
                                    });
                                    await transitionDialog(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      type: "Scale1",
                                      context: context,
                                      child: AddWindow(
                                        callBackFunction:
                                            widget.callBackFunction,
                                        isNew: true,
                                      ),
                                      builder: (BuildContext context) {
                                        return AddWindow(
                                            callBackFunction:
                                                widget.callBackFunction,
                                            isNew: true);
                                      },
                                    );
                                     SystemChrome.restoreSystemUIOverlays();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              height: stdButtonHeight * 0.75 * 0.8,
                              width: stdButtonHeight * 0.75 * 0.8,
                              decoration: BoxDecoration(
                                color: thisTheme.primaryColor,
                                borderRadius: BorderRadius.only(
                                    bottomRight:
                                        Radius.circular(stdBorderRadius),
                                    topRight: Radius.circular(stdBorderRadius)),
                              ),
                              child: FittedBox(
                                child: IconButton(
                                  splashRadius: stdButtonHeight * 0.75 * 0.45,
                                  icon: const Icon(
                                    Icons.folder_shared,
                                    color: Colors.white,
                                    //size: stdIconSize,
                                  ),
                                  tooltip: 'tooltip.add.stor'.tr(),
                                  onPressed: () async {
                                    setState(() {
                                      addButtonPressed = false;
                                    });

                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return PlayerList(
                                            saved: true,
                                            callbackFunction:
                                                widget.callBackFunction,
                                          );
                                        });
                                  },
                                ),
                              ),
                            ),
                          ]),
              ),
            ),
          )
        : const SizedBox();
  }
}