import 'package:flutter/material.dart';

import '../../../../../domain/models/game/game_state_enum.dart';
import '../../../../../utils/theme/ui_values.dart';
import 'card_rotation.dart';
import 'cards_variants/card_back.dart';
import 'cards_variants/card_front_sample.dart';

class TableCards extends StatelessWidget {
  final bool firstRow;
  final GameStatusEnum stateEnum;

  const TableCards.firstRow({
    required this.stateEnum,
    super.key,
  }) : firstRow = true;

  const TableCards.secondRow({
    required this.stateEnum,
    super.key,
  }) : firstRow = false;

  int get state {
    switch (stateEnum) {
      case GameStatusEnum.notStarted:
      case GameStatusEnum.preFlop:
        return 0;
      case GameStatusEnum.flop:
        return 1;
      case GameStatusEnum.turn:
        return 2;
      case GameStatusEnum.river:
        return 3;
      case GameStatusEnum.showdown:
        return 4;
      case GameStatusEnum.gameBreak:
        return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardCount = firstRow ? 3 : 2;
    final cardIndexAddition = firstRow ? 0 : 3;

    return Center(
      child: RotationCard(
        count: cardCount,
        conditionByIndex: (int index) =>
            (index + cardIndexAddition >= state % 5 + (state % 5 > 0 ? 2 : 0)),
        durationByIndex: (int index) => 500 + (index + cardIndexAddition) * 100,
        firstSide: (int index) => CardBack(),
        secondSide: (int index) => CardFrontSample(),
        padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 6),
      ),
    );
  }
}
