import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/cards/card_model.dart' as c;
import '../../../domain/models/cards/card_model.dart';
import '../../../domain/winner_solver.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../game/widgets/game_table/cards/card_rotation.dart';
import '../../game/widgets/game_table/cards/cards_variants/card_back.dart';
import '../../game/widgets/game_table/cards/cards_variants/card_front.dart';
import '../check_inherited.dart';
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

class _CheckPlayerState extends State<CheckPlayer> with ToastsMixin {
  void updateHand(int index, Card? card) {
    if (context.notInCards(card)) {
      context.playerCards![widget.number][index] = card;
      context.updateCombinations();
      widget.callback();
    } else {
      showToast(context.strings.check_toast);
    }
  }

  String handName(PokerHand hand, BuildContext context) {
    switch (hand) {
      case (PokerHand.highCard):
        return context.strings.check_hc;
      case (PokerHand.pair):
        return context.strings.check_p;
      case (PokerHand.twoPair):
        return context.strings.check_2p;
      case (PokerHand.threeOfAKind):
        return context.strings.check_tok;
      case (PokerHand.flush):
        return context.strings.check_f;
      case (PokerHand.fullHouse):
        return context.strings.check_fh;
      case (PokerHand.straight):
        return context.strings.check_s;
      case (PokerHand.fourOfAKind):
        return context.strings.check_fok;
      case (PokerHand.straightFlush):
        return context.strings.check_sf;
      case (PokerHand.royalFlush):
        return context.strings.check_rf;
      default:
        return '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: thisTheme.bankColor.withAlpha(0),
        ),
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
                  '  ${context.strings.check_player} ${widget.number + 1}${widget.winner ? ' 👑' : ''}',
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
                child: CardBack(),
              ),
              count: 2,
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
