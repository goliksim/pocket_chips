import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/cards/card_model.dart' as c;
import 'package:pocket_chips/presentation/game/widgets/game_table/cards/cards_variants/card_front.dart';

import '../test_utils/test_action.dart';

class SolverPageTester {
  final WidgetTester tester;

  SolverPageTester(this.tester);

  TAction verifyIsVisible() => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(SolverKeys.page), findsOneWidget);
      };

  TAction tapTableCardSlot(int index) => () async {
        await tester.pumpAndSettle();

        final frontFinder = find.byKey(SolverKeys.tableCardFront(index));
        final backFinder = find.byKey(SolverKeys.tableCardBack(index));
        await tester.tap(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction longPressTableCardSlot(int index) => () async {
        await tester.pumpAndSettle();

        final frontFinder = find.byKey(SolverKeys.tableCardFront(index));
        final backFinder = find.byKey(SolverKeys.tableCardBack(index));
        await tester.longPress(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction tapPlayerCardSlot(int playerIndex, int cardIndex) => () async {
        await tester.pumpAndSettle();

        final frontFinder = find.byKey(
          SolverKeys.playerCardButtonFront(playerIndex, cardIndex),
        );
        final backFinder = find.byKey(
          SolverKeys.playerCardButtonBack(playerIndex, cardIndex),
        );
        await tester
            .tap(frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder);
      };

  TAction longPressPlayerCardSlot(
    int playerIndex,
    int cardIndex,
  ) =>
      () async {
        await tester.pumpAndSettle();

        final frontFinder = find.byKey(
          SolverKeys.playerCardButtonFront(playerIndex, cardIndex),
        );
        final backFinder = find.byKey(
          SolverKeys.playerCardButtonBack(playerIndex, cardIndex),
        );
        await tester.longPress(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction pickCardValue(int value) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(SolverKeys.cardPickerValue(value)));
      };

  TAction pickCardSuit(String suit) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(SolverKeys.cardPickerSuit(suit)));
      };

  TAction verifyTableCardBackVisible(int index) => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(SolverKeys.tableCardBack(index)), findsOneWidget);
      };

  TAction verifyTableCardFrontVisible({
    required int index,
    required int value,
    required String suit,
  }) =>
      () async {
        await tester.pumpAndSettle();

        final cardFinder = find.byKey(SolverKeys.tableCardFront(index));
        final valueFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(SolverKeys.cardValue(value, suit)),
        );
        expect(cardFinder, findsOneWidget);
        expect(valueFinder, findsOneWidget);
      };

  TAction verifyPlayerCardBackVisible(
    int playerIndex,
    int cardIndex,
  ) =>
      () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(SolverKeys.playerCardBack(playerIndex, cardIndex)),
          findsOneWidget,
        );
      };

  TAction verifyPlayerCardFrontVisible({
    required int playerIndex,
    required int cardIndex,
    required int value,
    required String suit,
  }) =>
      () async {
        await tester.pumpAndSettle();

        final cardFinder =
            find.byKey(SolverKeys.playerCardFront(playerIndex, cardIndex));
        final valueFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(SolverKeys.cardValue(value, suit)),
        );
        expect(cardFinder, findsOneWidget);
        expect(valueFinder, findsOneWidget);
      };

  TAction verifyWinnerBadgeVisible(
    int playerIndex, {
    bool isVisible = true,
  }) =>
      () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(SolverKeys.winnerBadge(playerIndex)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  c.Card? getPlayerCard(int playerIndex, int cardIndex) {
    final widget = tester.widget<CardFront>(
      find.byKey(SolverKeys.playerCardFront(playerIndex, cardIndex)),
    );
    return widget.card;
  }

  TAction selectTableCard({
    required int index,
    required int value,
    required String suit,
  }) =>
      () async {
        await tester.pumpAndSettle();

        await runAction(tapTableCardSlot(index));
        await runAction(pickCardValue(value));
        await runAction(pickCardSuit(suit));

        await tester.pump(const Duration(seconds: 2));
      };

  TAction selectPlayerCard({
    required int playerIndex,
    required int cardIndex,
    required int value,
    required String suit,
  }) =>
      () async {
        await tester.pumpAndSettle();

        await runAction(tapPlayerCardSlot(playerIndex, cardIndex));
        await runAction(pickCardValue(value));
        await runAction(pickCardSuit(suit));

        await tester.pumpAndSettle();
      };
}
