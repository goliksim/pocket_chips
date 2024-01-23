// ignore_for_file: file_names
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_chips/data/logs.dart';
import 'package:pocket_chips/internal/localization.dart';
import 'package:pocket_chips/pages/gamepage/game_contol/game_table/game_table.dart';

import '../../internal/gamelogic.dart';
import '../../ui/ui_widgets.dart';
import '../../data/storage.dart';
import '../../data/lobby.dart';
import '../../ui/transitions.dart';
import '../playersPage.dart';
import '../../data/uiValues.dart';
import 'game_contol/game_control.dart';

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
      'Game was loaded with state: ${thisLobby.lobbyState}\t isActive: ${thisLobby.lobbyIsActive}',
    );

    // Действия только на старте
    if (!thisLobby.lobbyIsActive) {
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
      if (thisLobby.lobbyIndex >= 0 && thisLobby.lobbyIndex < 4) {
        thisGame.gameStateName = Text(
          '${LocaleManager.locale.game_turn1}\u00A0${LocaleManager.locale.game_turn2}\u00A0${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}',
          style: TextStyle(color: thisTheme.onBackground),
        );
      }
      //а вдруг крашнулось на выборе, тогда снова выведем окно
      Future.delayed(const Duration(milliseconds: 200), () {
        if (thisLobby.lobbyState == 4) {
          thisGame.newLap();
        }
      });
    }
    //восстановление после выхода или перезапуска
    thisGame.context = context;
    thisGame.callback = () {
      if (mounted) {
        setState(() {});
      }
    };
    //thisGame.raiseButtonPressed = false;
    thisGame.bidsEqual = thisGame.waitForBidsEqual();
    //повторная проверка, а вдруг сделали закуп
    if (thisLobby.lobbyState == 5) {
      for (Player player in thisLobby.lobbyPlayers) {
        player.isActive = !(player.bank <= 0);
        //player.isActive = !(player.bank < thisLobby.lobbySmallBlind * 2);
      }
    }
  }

  void callback() {
    setState(() {});
    lobbyStorage.write(thisLobby);
  }

  @override
  Widget build(BuildContext context) {
    return PatternContainer(
      opacity: 0.5,
      padding: EdgeInsets.only(
        top: stdCutoutWidth * 0.75,
        bottom: stdCutoutWidthDown * 0.75,
      ),
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
          titleTextStyle:
              appBarStyle().copyWith(fontSize: stdFontSize / 20 * 22),
          elevation: 0,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
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
                        tooltip: context.locale.tooltip_rot,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //Buttons
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: GameTable(
                  callBack: callback,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                adaptiveOffset,
                0,
                adaptiveOffset,
                adaptiveOffset,
              ),
              child: GameControl(
                callback: callback,
                //key: UniqueKey(),
              ),
            ),
          ],
        ),
      ),
    );
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
                          animation.value,
                          1.0,
                          1.0,
                        ),
                        alignment: Alignment.center,
                        child: widget,
                      );
                    },
                  );
                },
                child: !addButtonPressed
                    ? Container(
                        key: const ValueKey('1'),
                        height: stdButtonHeight * 0.75 * 0.8,
                        width: stdButtonHeight * 0.75 * 0.8,
                        decoration: BoxDecoration(
                          color: thisTheme.primaryColor,
                          borderRadius:
                              BorderRadius.circular(stdBorderRadius * 2),
                        ),
                        child: FittedBox(
                          child: IconButton(
                            tooltip: context.locale.tooltip_add_main,
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
                        key: const ValueKey('2'),
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
                                topLeft: Radius.circular(stdBorderRadius * 2),
                              ),
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
                                tooltip: context.locale.tooltip_add_new,
                                onPressed: () async {
                                  setState(() {
                                    addButtonPressed = false;
                                  });
                                  await transitionDialog(
                                    duration: const Duration(milliseconds: 400),
                                    type: 'Scale1',
                                    context: context,
                                    child: AddWindow(
                                      callBackFunction: widget.callBackFunction,
                                      isNew: true,
                                    ),
                                    builder: (BuildContext context) {
                                      return AddWindow(
                                        callBackFunction:
                                            widget.callBackFunction,
                                        isNew: true,
                                      );
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
                                bottomRight: Radius.circular(stdBorderRadius),
                                topRight: Radius.circular(stdBorderRadius),
                              ),
                            ),
                            child: FittedBox(
                              child: IconButton(
                                splashRadius: stdButtonHeight * 0.75 * 0.45,
                                icon: const Icon(
                                  Icons.folder_shared,
                                  color: Colors.white,
                                  //size: stdIconSize,
                                ),
                                tooltip: context.locale.tooltip_add_stor,
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
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )
        : const SizedBox();
  }
}
