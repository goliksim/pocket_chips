import 'package:flutter/material.dart';

import '../../../../../data/uiValues.dart';
import '../../../../../internal/localization.dart';
import '../../../../../ui/dialog_widget.dart';
import '../../../../../ui/transitions.dart';
import 'check_inherited.dart';
import 'check_player.dart';
import 'check_table.dart';

Future showWinChecker(BuildContext context) => transitionDialog(
      duration: const Duration(milliseconds: 400),
      type: 'Scale',
      context: context,
      child: CheckCardsInherited(
        winner: -1,
        playerCards: List.generate(2, (index) => [null, null]),
        combinations: List.filled(2, null),
        tableCards: List.filled(5, null),
        child: const WinnerChecker(),
      ),
      builder: (BuildContext context) {
        return CheckCardsInherited(
          winner: -1,
          playerCards: List.generate(2, (index) => [null, null]),
          combinations: List.filled(2, null),
          tableCards: List.filled(5, null),
          child: const WinnerChecker(),
        );
      },
    );

class WinnerChecker extends StatefulWidget {
  const WinnerChecker({super.key});

  @override
  State<WinnerChecker> createState() => _WinnerCheckerState();
}

class _WinnerCheckerState extends State<WinnerChecker> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      edgeOffset: stdHorizontalOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: stdButtonHeight * 0.5,
            child: Center(
              child: FittedBox(
                child: Text(
                  context.locale.home_win_check,
                  style: TextStyle(
                    color: thisTheme.onBackground,
                    fontSize: stdFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          CheckTable(
            callback: callback,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int playerIndex = 0;
                  playerIndex < context.playerCards!.length;
                  playerIndex++)
                Flexible(
                  child: CheckPlayer(
                    callback: callback,
                    cards: context.playerCards![playerIndex],
                    number: playerIndex,
                    winner: context.winner == playerIndex,
                    combination: context.combinations[playerIndex]?.hand,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: stdHorizontalOffset / 2,
          ),
        ],
      ),
    );
  }
}
