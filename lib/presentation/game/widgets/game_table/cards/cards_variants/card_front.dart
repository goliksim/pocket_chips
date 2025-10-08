import 'package:flutter/material.dart';

import '../../../../../../domain/models/cards/card_model.dart' as c;
import '../../../../../../utils/theme/uiValues.dart';
import '../card_widget.dart';

class CardFront extends StatelessWidget {
  const CardFront({super.key, this.card});
  final c.Card? card;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: ColoredBox(
        color: (thisTheme.name == 'dark')
            ? thisTheme.bankColor
            : thisTheme.playerColor,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: stdHorizontalOffset / 2,
              left: stdHorizontalOffset / 2,
              child: Text(
                card!.keyString,
                style: TextStyle(
                  color: thisTheme.onBackground,
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
                  card!.keyString,
                  style: TextStyle(
                    color: thisTheme.onBackground,
                    fontSize: stdFontSize * 0.6,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Icon(
                c.cardsIconMap[card!.suit.name],
                color: ['s', 'c'].any((e) => e == card!.suit.name)
                    ? thisTheme.onBackground
                    : Colors.red,
                size: stdFontSize * 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
