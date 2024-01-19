import 'package:flutter/material.dart';
import 'package:pocket_chips/data/lobby.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/pages/gamepage/gamePage.dart';
import 'package:pocket_chips/pages/gamepage/game_contol/game_table/player_window.dart';

import 'table_cards.dart';
import 'table_service.dart';

class GameTable extends StatelessWidget {
  const GameTable({super.key, required this.callBack});
  final Function() callBack;

  @override
  Widget build(BuildContext context) {
    double tableButtonWidth =
        MediaQuery.of(context).size.width - adaptiveOffset;
    double tableHeight = MediaQuery.of(context).size.height;
    int addButton = (thisLobby.lobbyPlayers.length >= maxPlayerCount ? 0 : 1);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        //Table
        Container(
          //duration: Duration(milliseconds: 500),
          margin: EdgeInsets.only(
            top: stdButtonHeight / 3,
            bottom: stdButtonHeight / 3,
          ),
          //height: 550,
          decoration: BoxDecoration(
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              colorFilter: ColorFilter.mode(
                thisTheme.primaryColor.withOpacity(
                  thisTheme.name == 'light' ? 0.075 : 0,
                ),
                BlendMode.srcATop,
              ),
              fit: BoxFit.contain,
              image: AssetImage(
                'assets/table_${thisTheme.name}.png',
              ),
            ),
          ),
        ),
        // 3 карты по середине
        Positioned(
          bottom: 3.8 * stdButtonHeight,
          child: TableCards(
            state: thisLobby.lobbyState,
            count: 0,
          ),
        ),
        // 2 карты по середине
        Positioned(
          bottom: 3 * stdButtonHeight,
          child: TableCards(
            state: thisLobby.lobbyState,
            count: 1,
          ),
        ),
        Positioned(
          bottom: 2.5 * stdButtonHeight,
          child: Text(
            '${thisLobby.lobbySmallBlind} / ${thisLobby.lobbySmallBlind * 2}',
            style: TextStyle(
              color: thisTheme.onBackground.withOpacity(0.3),
              fontSize: stdFontSize * 0.6,
            ),
          ),
        ),
        // Общая ставка
        Positioned(
          bottom: 2.175 * stdButtonHeight,
          child: FittedBox(
            child: Container(
              height: stdHeight / 2.5,
              padding: EdgeInsets.symmetric(
                horizontal: stdHorizontalOffset / 2,
              ),
              decoration: BoxDecoration(
                color: thisTheme.primaryColor,
                borderRadius: BorderRadius.circular(
                  stdBorderRadius,
                ),
              ),
              child: Center(
                child: Text(
                  '\$ ${thisLobby.lobbyPlayers.map((e) => e.bid).reduce((a, b) => a + b)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: stdFontSize * 0.75,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Карточки игроков

        for (int player = 0;
            player < thisLobby.lobbyPlayers.length + addButton;
            player++)
          Positioned(
            bottom: playerBottomOffset(player, addButton, tableHeight),
            left: playerLeftOffset(tableButtonWidth, player, addButton),
            child: ((player == 0) && (addButton > 0))
                ? AddBottom(
                    callBackFunction: callBack,
                  )
                : PlayerField(
                    a: (player - addButton - thisLobby.elementsOffset) %
                        thisLobby.lobbyPlayers.length,
                    index: player - addButton,
                    addButton: addButton,
                    callBack: callBack,
                  ), // playerCard(a - addButton) - без крутежки игроков
          ),
        // Ставки игроков
        for (int a = addButton;
            a < thisLobby.lobbyPlayers.length + addButton;
            a++)
          Positioned(
            bottom: chipBottomOffset(a, addButton),
            left: chipsLeftOffset(tableButtonWidth, a, addButton),
            child: (thisLobby
                        .lobbyPlayers[
                            (a - addButton - thisLobby.elementsOffset) %
                                thisLobby.lobbyPlayers.length]
                        .bid !=
                    0)
                ? chip(
                    (a - addButton - thisLobby.elementsOffset) %
                        thisLobby.lobbyPlayers.length,
                  ) //chip((a - addButton) - без крутежки игроков
                : const SizedBox(),
          ),
      ],
    );
  }
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
          child: Text(
            '\$ ${thisLobby.lobbyPlayers[a].bid}',
            style: TextStyle(
              color: thisTheme.onBackground.withOpacity(0.6),
              fontSize: stdFontSize * 0.75,
            ),
          ),
        ),
      ),
    );

double playerLeftOffset(tableButtonWidth, a, addButton) =>
    tableButtonWidth / 3 -
    (stdButtonHeight * 1.6 * getSin(a, addButton, multiply: -0.5));

double playerBottomOffset(a, addButton, tableHeight) =>
    tableHeight / 3.3 - 3.2 * stdButtonHeight * getCos(a, addButton);
//3.4 * stdButtonHeight - 3.2 * stdButtonHeight * getCos(a, addButton);

double chipBottomOffset(a, addButton) =>
    -3.08 * stdButtonHeight * getCos(a, addButton) +
    3.55 * stdButtonHeight -
    (getCos(a, addButton) > 0.01
        ? -stdButtonHeight * 0.5
        : stdButtonHeight * 0.5);

double chipsLeftOffset(tableButtonWidth, a, addButton) =>
    (tableButtonWidth) / 2.9 -
    (stdButtonHeight *
        1.25 *
        getSin(
          a,
          addButton,
          multiply: -1,
        ));
