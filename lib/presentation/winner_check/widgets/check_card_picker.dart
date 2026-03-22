import 'package:flutter/material.dart';

import '../../../app/keys/keys.dart';
import '../../../domain/models/cards/card_model.dart' as c;
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';

class CardPicker extends StatefulWidget {
  final Function(c.Card?) action;

  const CardPicker({
    required this.action,
    super.key,
  });

  @override
  State<CardPicker> createState() => _CardPickerState();
}

class _CardPickerState extends State<CardPicker> {
  int? pickedKey;
  String? pickedSuit;

  void _updateKey(int key) {
    pickedKey = key;
    setState(() {});
  }

  void _updateSuit(String suit) {
    pickedSuit = suit;
    setState(() {});
  }

  void _returnCard(BuildContext context) {
    if (pickedKey != null && pickedSuit != null) {
      Future.delayed(const Duration(milliseconds: 400)).then(
        (_) {
          widget.action(c.Card(c.mapSuit[pickedSuit]!, pickedKey!));
          pop();
        },
      );
    }
  }

  void pop() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    _returnCard(context);
    return Dialog(
      key: SolverKeys.cardPickerDialog,
      elevation: 0,
      backgroundColor: context.theme.bgrColor,
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
                    context.strings.check_picker,
                    style: TextStyle(
                      color: context.theme.onBackground,
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
                    Flexible(
                      child: _keyButton(
                        index,
                        pickedKey,
                        _updateKey,
                        context,
                        key: SolverKeys.cardPickerValue(index),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int index = 8; index >= 2; index--)
                    Flexible(
                      child: _keyButton(
                        index,
                        pickedKey,
                        _updateKey,
                        context,
                        key: SolverKeys.cardPickerValue(index),
                      ),
                    ),
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
                      child: _suitButton(
                        c.CardSuit.values[index].name,
                        pickedSuit,
                        _updateSuit,
                        context,
                        key: SolverKeys.cardPickerSuit(
                          c.CardSuit.values[index].name,
                        ),
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

Widget _keyButton(
  int index,
  int? picked,
  Function(int) action,
  BuildContext context, {
  Key? key,
}) =>
    AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => action(index),
        child: Card(
          key: key,
          margin: EdgeInsets.all(stdHorizontalOffset / 6),
          color: context.theme.bgrColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: index != picked
                  ? context.theme.bankColor
                  : context.theme.primaryColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(stdBorderRadius / 2)),
          ),
          child: Center(
            child: Text(
              c.cardTextReversed[index]!,
              style: TextStyle(
                color: context.theme.onBackground,
                fontSize: stdFontSize,
              ),
            ),
          ),
        ),
      ),
    );

Widget _suitButton(
  String suit,
  String? picked,
  Function(String) action,
  BuildContext context, {
  Key? key,
}) =>
    AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => action(suit),
        child: Card(
          key: key,
          margin: EdgeInsets.all(stdHorizontalOffset / 6),
          color: context.theme.bankColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: suit != picked
                  ? context.theme.bankColor
                  : context.theme.primaryColor,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(stdBorderRadius / 2)),
          ),
          child: Center(
            child: Icon(
              c.cardsIconMap[suit],
              color: ['s', 'c'].any((e) => e == suit)
                  ? context.theme.onBackground
                  : Colors.red,
              size: stdFontSize,
            ),
          ),
        ),
      ),
    );
