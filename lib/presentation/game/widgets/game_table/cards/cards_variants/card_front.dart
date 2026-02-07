import 'package:flutter/material.dart';

import '../../../../../../app/keys/keys.dart';
import '../../../../../../domain/models/cards/card_model.dart' as c;
import '../../../../../../utils/extensions.dart';
import '../../../../../../utils/theme/ui_values.dart';
import '../card_widget.dart';

class CardFront extends StatelessWidget {
  final c.Card card;

  const CardFront({
    required this.card,
    super.key,
  });

  @override
  Widget build(BuildContext context) => CardWidget(
        key: SolverKeys.cardValue(card.key, card.suit.name),
        child: ColoredBox(
          color: (context.theme.name == 'dark')
              ? context.theme.bankColor
              : context.theme.playerColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: stdHorizontalOffset / 2,
                left: stdHorizontalOffset / 2,
                child: Text(
                  card.keyString,
                  style: TextStyle(
                    color: context.theme.onBackground,
                    fontSize: stdFontSize * 0.6,
                  ),
                ),
              ),
              Positioned(
                bottom: stdHorizontalOffset / 2,
                right: stdHorizontalOffset / 2,
                child: Transform.flip(
                  flipY: true,
                  flipX: true,
                  child: Text(
                    card.keyString,
                    style: TextStyle(
                      color: context.theme.onBackground,
                      fontSize: stdFontSize * 0.6,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Icon(
                  c.cardsIconMap[card.suit.name],
                  color: ['s', 'c'].any((e) => e == card.suit.name)
                      ? context.theme.onBackground
                      : Colors.red,
                  size: stdFontSize * 1.5,
                ),
              ),
            ],
          ),
        ),
      );
}
