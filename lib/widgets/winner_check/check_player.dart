import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/internal/cards/winner_gpt.dart';
import 'package:pocket_chips/internal/localization.dart';
import 'package:pocket_chips/ui/cards/card_rotation.dart';
import 'package:pocket_chips/ui/cards/cards_variants/card_back.dart';
import 'package:pocket_chips/ui/cards/cards_variants/card_front.dart';
import 'package:pocket_chips/internal/cards/card_model.dart' as c;
import 'package:pocket_chips/ui/ui_widgets.dart';
import 'package:pocket_chips/widgets/winner_check/check_inherited.dart';

import 'check_card_button.dart';

class CheckPlayer extends StatefulWidget {
  const CheckPlayer({
    super.key,
    required this.number,
    this.winner = false,
    this.combination,
    required this.cards,
    required this.callback,
  });
  final void Function() callback;
  final int number;
  final bool winner;
  final PokerHand? combination;
  final List<c.Card?> cards;

  @override
  State<CheckPlayer> createState() => _CheckPlayerState();
}

class _CheckPlayerState extends State<CheckPlayer> {
  void updateHand(index, card) {
    if (context.notInCards(card)) {
      context.playerCards![widget.number][index] = card;
      context.updateCombinations();
      widget.callback();
    } else {
      showToast(context.locale.check_toast);
    }
  }

  String handName(PokerHand hand, BuildContext context) {
    switch (hand) {
      case (PokerHand.highCard):
        return context.locale.check_hc;
      case (PokerHand.pair):
        return context.locale.check_p;
      case (PokerHand.twoPair):
        return context.locale.check_2p;
      case (PokerHand.threeOfAKind):
        return context.locale.check_tok;
      case (PokerHand.flush):
        return context.locale.check_f;
      case (PokerHand.fullHouse):
        return context.locale.check_fh;
      case (PokerHand.straight):
        return context.locale.check_s;
      case (PokerHand.fourOfAKind):
        return context.locale.check_fok;
      case (PokerHand.straightFlush):
        return context.locale.check_sf;
      case (PokerHand.royalFlush):
        return context.locale.check_rf;
      default:
        return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(width: 2.0, color: thisTheme.bankColor.withOpacity(0)),
        borderRadius: BorderRadius.all(
          Radius.circular(
            stdBorderRadius,
          ), //                 <--- border radius here
        ),
      ),
      height: 170.h,
      child: Column(
        children: [
          SizedBox(
            height: stdButtonHeight * 0.5,
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  '  ${context.locale.check_player} ${widget.number + 1}${widget.winner ? ' 👑' : ''}',
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
              firstSide: (int index) => CardButton(
                action: (card) {
                  updateHand(index, card);
                },
                child: CardFront(
                  card: context.playerCards![widget.number][index],
                ),
              ),
              secondSide: (int index) => CardButton(
                action: (card) {
                  updateHand(index, card);
                },
                child: cardBack,
              ),
              count: 1,
              conditionByIndex: (int index) => widget.cards[index] != null,
              durationByIndex: (int index) => 500,
              padding: EdgeInsets.all(stdHorizontalOffset / 3),
            ),
          ),
          SizedBox(
            height: stdButtonHeight * 0.4,
            child: Center(
              child: FittedBox(
                child: Text(
                  widget.combination == null
                      ? '...'
                      : handName(widget.combination!, context),
                  style: TextStyle(
                    color: thisTheme.primaryColor,
                    fontSize: stdFontSize * 0.9,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
