import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pocket_chips/internal/cards/card_model.dart' as c;
import 'package:pocket_chips/ui/dialog_widget.dart';
import 'package:pocket_chips/ui/transitions.dart';
import 'package:pocket_chips/widgets/winner_check/card_widget.dart';

Future showWinChecker(BuildContext context) => transitionDialog(
      duration: const Duration(milliseconds: 400),
      type: 'Scale',
      context: context,
      child: const WinnerChecker(),
      builder: (BuildContext context) {
        return const WinnerChecker();
      },
    );

class WinnerChecker extends StatefulWidget {
  const WinnerChecker({super.key});

  @override
  State<WinnerChecker> createState() => _WinnerCheckerState();
}

class _WinnerCheckerState extends State<WinnerChecker> {
  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      child: SizedBox(
        height: 100.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: CardWidget(card: c.Card(c.CardSuit.c, 1))),
            Expanded(child: CardWidget(card: c.Card(c.CardSuit.c, 1))),
            Expanded(child: CardWidget(card: c.Card(c.CardSuit.c, 1))),
            Expanded(child: CardWidget(card: c.Card(c.CardSuit.c, 1))),
            Expanded(child: CardWidget(card: c.Card(c.CardSuit.c, 1))),
          ],
        ),
      ),
    );
  }
}
