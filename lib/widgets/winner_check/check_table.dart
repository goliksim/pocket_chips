import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../data/uiValues.dart';
import '../../../../../internal/localization.dart';
import '../../../../../ui/cards/card_rotation.dart';
import '../../../../../ui/cards/cards_variants/card_back.dart';
import '../../../../../ui/cards/cards_variants/card_front.dart';
import '../../../../../ui/ui_widgets.dart';
import '../../../../../widgets/winner_check/check_inherited.dart';
import '../../internal/cards/card_model.dart';
import 'check_card_button.dart';

class CheckTable extends StatefulWidget {
  const CheckTable({super.key, required this.callback});
  final void Function() callback;
  @override
  State<CheckTable> createState() => _CheckTableState();
}

class _CheckTableState extends State<CheckTable> {
  void updateTable(int index, Card? card) {
    if (context.notInCards(card)) {
      context.tableCards![index] = card;
      context.updateCombinations();
      widget.callback();
    } else {
      showToast(context.locale.check_toast);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: thisTheme.bankColor),
        borderRadius: BorderRadius.all(
          Radius.circular(
            stdBorderRadius,
          ), //                 <--- border radius here
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
                  context.locale.check_table,
                  style: TextStyle(
                    color: thisTheme.onBackground,
                    fontSize: stdFontSize,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: RotationCard(
              count: 0,
              conditionByIndex: (int index) =>
                  context.tableCards![index] != null,
              durationByIndex: (int index) => 500,
              firstSide: (int index) => CardButton(
                action: (card) {
                  updateTable(index, card);
                },
                child: CardFront(card: context.tableCards![index]),
              ),
              secondSide: (int index) => CardButton(
                action: (card) {
                  updateTable(index, card);
                },
                child: cardBack,
              ),
              padding: EdgeInsets.all(stdHorizontalOffset / 2),
            ),
          ),
          Flexible(
            child: RotationCard(
              count: 1,
              conditionByIndex: (int index) =>
                  context.tableCards![index + 3] != null,
              durationByIndex: (int index) => 500,
              firstSide: (int index) => CardButton(
                action: (card) {
                  updateTable(index + 3, card);
                },
                child: CardFront(card: context.tableCards![index + 3]),
              ),
              secondSide: (int index) => CardButton(
                action: (card) {
                  updateTable(index + 3, card);
                },
                child: cardBack,
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
}
