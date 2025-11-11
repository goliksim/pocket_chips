import 'package:flutter/material.dart';

import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/dialog_widget.dart';
import 'check_inherited.dart';
import 'widgets/check_player.dart';
import 'widgets/check_table.dart';

class WinnerChecker extends StatelessWidget {
  const WinnerChecker({super.key});

  @override
  Widget build(BuildContext context) => CheckCardsInherited(
        winner: -1,
        playerCards: List.generate(2, (index) => [null, null]),
        combinations: List.filled(2, null),
        tableCards: List.filled(5, null),
        child: Builder(builder: (context) => _WinnerCheck()),
      );
}

class _WinnerCheck extends StatefulWidget {
  const _WinnerCheck();

  @override
  State<_WinnerCheck> createState() => __WinnerCheckState();
}

class __WinnerCheckState extends State<_WinnerCheck> {
  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => DialogWidget(
        edgeOffset: stdHorizontalOffset,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: FittedBox(
                  child: Text(
                    context.strings.home_win_check,
                    style: TextStyle(
                      color: context.theme.onBackground,
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
