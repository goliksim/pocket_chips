import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../data/lobby.dart';
import '../../../../../data/uiValues.dart';
import '../../../../../internal/gamelogic.dart';
import '../../../../../internal/localization.dart';
import '../../../../../pages/playersPage.dart';
import '../../../../../ui/transitions.dart';
import '../../../../../ui/ui_widgets.dart';

class PlayerField extends StatelessWidget {
  const PlayerField({
    super.key,
    required this.a,
    required this.index,
    required this.addButton,
    required this.callBack,
  });
  final int a;
  final int index;
  final int addButton;
  final Function() callBack;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
                .withAlpha(thisLobby.lobbyPlayers[a].isActive ? 255 : 128),
        longAction: () async {
          await transitionDialog(
            duration: const Duration(milliseconds: 400),
            type: 'Scale1',
            //barrierColor: null,
            context: context,
            child: AddWindow(
              player: thisLobby.lobbyPlayers[a],
              callBackFunction: callBack,
              playerIndex: a,
              settingsBool: (thisLobby.lobbyState == 5),
            ),
            builder: (BuildContext context) {
              return AddWindow(
                player: thisLobby.lobbyPlayers[a],
                callBackFunction: callBack,
                playerIndex: a,
                settingsBool: (thisLobby.lobbyState == 5),
              );
            },
          ).then((value) {
            thisGame.gameStateName = Text(
              '${context.locale.game_turn1}\u00A0${context.locale.game_turn2}\u00A0${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name}',
              style: TextStyle(color: thisTheme.onBackground),
            );
          });
          SystemChrome.restoreSystemUIOverlays();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: sin(
                    2 *
                        pi *
                        (index / (thisLobby.lobbyPlayers.length - addButton)),
                  ) <
                  0
              ? reversablePlayerWidgetList(a)
              : List.from(reversablePlayerWidgetList(a).reversed),
        ),
      ),
    );
  }
}

// В зависимости от значения, возвращает либо лого персонажа, либо имя с банком
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
              filterQuality: FilterQuality.medium,
              image: AssetImage(
                thisLobby.lobbyPlayers[index].assetUrl,
              ),
              colorFilter: ColorFilter.mode(
                Colors.white.withAlpha(
                  thisLobby.lobbyPlayers[index].isActive ? 255 : 50,
                ),
                BlendMode.modulate,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
        thisLobby.lobbyPlayers[index].isDealer
            ? Container(
                width: stdHeight,
                height: stdHeight,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    filterQuality: FilterQuality.medium,
                    image: const AssetImage(
                      'assets/chips/dealer.png',
                    ),
                    colorFilter: ColorFilter.mode(
                      Colors.white.withAlpha(
                        thisLobby.lobbyPlayers[index].isActive ? 255 : 50,
                      ),
                      BlendMode.modulate,
                    ),
                    fit: BoxFit.fill,
                  ),
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
                      : thisTheme.onBackground.withAlpha(
                          thisLobby.lobbyPlayers[index].isActive ? 255 : 50,
                        ),
                  fontWeight: FontWeight.bold,
                  fontSize: stdFontSize,
                ),
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  '${thisLobby.lobbyPlayers[index].bank}',
                  style: TextStyle(
                    fontSize: stdFontSize * 0.75,
                    color: (index == thisLobby.lobbyIndex)
                        ? thisTheme.onPrimary
                        : thisTheme.onBackground.withAlpha(
                            thisLobby.lobbyPlayers[index].isActive ? 255 : 50,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    SizedBox(width: stdHorizontalOffset / 2),
  ];
}
