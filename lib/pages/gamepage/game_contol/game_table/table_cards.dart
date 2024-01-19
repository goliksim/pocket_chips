import 'package:flutter/material.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/ui/cards/card_rotation.dart';
import 'package:pocket_chips/ui/cards/cards_variants/card_back.dart';
import 'package:pocket_chips/ui/cards/cards_variants/card_front_sample.dart';

class TableCards extends StatelessWidget {
  const TableCards({super.key, required this.count, required this.state});
  final int count;
  final int state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: stdButtonHeight * 0.75,
      width: stdButtonHeight * 0.75 * (3 - count) * 0.75,
      child: Center(
        child: RotationCard(
          count: count,
          conditionByIndex: (int index) =>
              (index + 3 * count >= state % 5 + (state % 5 > 0 ? 2 : 0)),
          durationByIndex: (int index) => 500 + (index + 3 * count) * 100,
          firstSide: (int index) => cardBack,
          secondSide: (int index) => cardSample,
          padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 6),
        ),
      ),
    );
  }
}
