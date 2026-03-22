import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/keys/keys.dart';
import '../../../domain/models/cards/card_model.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../game/widgets/game_table/cards/card_rotation.dart';
import '../../game/widgets/game_table/cards/cards_variants/card_back.dart';
import '../../game/widgets/game_table/cards/cards_variants/card_front.dart';
import '../check_inherited.dart';
import 'check_card_button.dart';

class CheckTable extends StatefulWidget {
  final VoidCallback callback;

  const CheckTable({
    required this.callback,
    super.key,
  });

  @override
  State<CheckTable> createState() => _CheckTableState();
}

class _CheckTableState extends State<CheckTable> with ToastsMixin {
  void updateTable(int index, Card? card) {
    if (context.notInCards(card)) {
      context.tableCards[index] = card;
      context.updateCombinations();
      widget.callback();
    } else {
      showToast(context.strings.check_toast);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: context.theme.bankColor),
          borderRadius: BorderRadius.all(
            Radius.circular(stdBorderRadius), // <--- border radius here
          ),
        ),
        height: 300.h,
        child: Column(
          children: [
            SizedBox(
              height: stdButtonHeight * 0.5,
              child: Center(
                child: FittedBox(
                  child: Text(
                    context.strings.check_table,
                    style: TextStyle(
                      color: context.theme.onBackground,
                      fontSize: stdFontSize,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: RotationCard(
                count: 3,
                conditionByIndex: (int index) =>
                    context.tableCards[index] != null,
                durationByIndex: (int index) => 500,
                firstSide: (int index) {
                  final card = context.tableCards[index]!;

                  return CardButton(
                    key: SolverKeys.tableCardFront(index),
                    action: (card) {
                      updateTable(index, card);
                    },
                    child: CardFront(card: card),
                  );
                },
                secondSide: (int index) => CardButton(
                  key: SolverKeys.tableCardBack(index),
                  action: (card) {
                    updateTable(index, card);
                  },
                  child: CardBack(),
                ),
                padding: EdgeInsets.all(stdHorizontalOffset / 2),
              ),
            ),
            Flexible(
              child: RotationCard(
                count: 2,
                conditionByIndex: (int index) =>
                    context.tableCards[index + 3] != null,
                durationByIndex: (int index) => 500,
                firstSide: (int index) {
                  final card = context.tableCards[index + 3]!;

                  return CardButton(
                    key: SolverKeys.tableCardFront(index + 3),
                    action: (card) {
                      updateTable(index + 3, card);
                    },
                    child: CardFront(card: card),
                  );
                },
                secondSide: (int index) => CardButton(
                  key: SolverKeys.tableCardBack(index + 3),
                  action: (card) {
                    updateTable(index + 3, card);
                  },
                  child: CardBack(),
                ),
                padding: EdgeInsets.all(stdHorizontalOffset / 2),
              ),
            ),
            SizedBox(
              height: stdButtonHeight * 0.25,
            ),
          ],
        ),
      );
}
