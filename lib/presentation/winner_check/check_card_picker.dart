import 'package:flutter/material.dart';

import '../../domain/models/cards/card_model.dart' as c;
import '../../l10n/localization.dart';
import '../../utils/theme/uiValues.dart';

class CardPicker extends StatefulWidget {
  const CardPicker({
    required this.action,
    super.key,
  });
  final Function(c.Card?) action;

  @override
  State<CardPicker> createState() => _CardPickerState();
}

class _CardPickerState extends State<CardPicker> {
  int? pickedKey;
  String? pickedSuit;

  void updateKey(int key) {
    pickedKey = key;
    setState(() {});
  }

  void updateSuit(String suit) {
    pickedSuit = suit;
    setState(() {});
  }

  void returnCard(BuildContext context) {
    if (pickedKey != null && pickedSuit != null) {
      Future.delayed(const Duration(milliseconds: 400)).then(
        (_) {
          widget.action(c.Card(c.mapSuit[pickedSuit]!, pickedKey!));
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    returnCard(context);
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: adaptiveOffset,
      ), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
      ),
      child: Container(
        padding: EdgeInsets.all(
          stdHorizontalOffset,
        ),
        width: stdButtonWidth,
        height: stdDialogHeight / 1.05,
        child: Column(
          children: [
            SizedBox(
              height: stdButtonHeight * 0.4,
              child: Center(
                child: FittedBox(
                  child: Text(
                    context.locale.check_picker,
                    style: TextStyle(
                      color: thisTheme.onBackground,
                      fontSize: stdFontSize,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: stdHorizontalOffset,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 14; index > 8; index--)
                    Flexible(child: keyButton(index, pickedKey, updateKey)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 8; index >= 2; index--)
                    Flexible(child: keyButton(index, pickedKey, updateKey)),
                ],
              ),
            ),
            SizedBox(
              height: stdHorizontalOffset / 2,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 0; index < 4; index++)
                    Flexible(
                      child: suitButton(
                        ['s', 'c', 'h', 'd'][index],
                        pickedSuit,
                        updateSuit,
                      ),
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

Widget keyButton(int index, int? picked, Function(int) action) => AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => action(index),
        child: Card(
          margin: EdgeInsets.all(stdHorizontalOffset / 6),
          color: thisTheme.bgrColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: index != picked
                  ? thisTheme.bankColor
                  : thisTheme.primaryColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(stdBorderRadius / 2)),
          ),
          child: Center(
            child: Text(
              c.cardTextReversed[index]!,
              style: TextStyle(
                color: thisTheme.onBackground,
                fontSize: stdFontSize,
              ),
            ),
          ),
        ),
      ),
    );

Widget suitButton(String suit, String? picked, Function(String) action) =>
    AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => action(suit),
        child: Card(
          margin: EdgeInsets.all(stdHorizontalOffset / 6),
          color: thisTheme.bankColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color:
                  suit != picked ? thisTheme.bankColor : thisTheme.primaryColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(stdBorderRadius / 2)),
          ),
          child: Center(
            child: Icon(
              c.cardsIconMap[suit],
              color: ['s', 'c'].any((e) => e == suit)
                  ? thisTheme.onBackground
                  : Colors.red,
              size: stdFontSize,
            ),
          ),
        ),
      ),
    );
