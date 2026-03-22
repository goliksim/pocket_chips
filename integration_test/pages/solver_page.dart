import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/cards/card_model.dart' as c;
import 'package:pocket_chips/presentation/game/widgets/game_table/cards/cards_variants/card_front.dart';

import '../test_utils/test_action.dart';

class SolverPageTester {
  final PatrolTester $;

  SolverPageTester(this.$);

  TAction verifyVisibility() => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(SolverKeys.page), findsOneWidget);
      };

  TAction tapTableCardSlot(int index) => () async {
        await $.tester.pumpAndSettle();

        final frontFinder = find.byKey(SolverKeys.tableCardFront(index));
        final backFinder = find.byKey(SolverKeys.tableCardBack(index));
        await $.tester.tap(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction longPressTableCardSlot(int index) => () async {
        await $.tester.pumpAndSettle();

        final frontFinder = find.byKey(SolverKeys.tableCardFront(index));
        final backFinder = find.byKey(SolverKeys.tableCardBack(index));
        await $.tester.longPress(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction tapPlayerCardSlot(int playerIndex, int cardIndex) => () async {
        await $.tester.pumpAndSettle();

        final frontFinder = find.byKey(
          SolverKeys.playerCardButtonFront(playerIndex, cardIndex),
        );
        final backFinder = find.byKey(
          SolverKeys.playerCardButtonBack(playerIndex, cardIndex),
        );
        await $
            .tap(frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder);
      };

  TAction longPressPlayerCardSlot(
    int playerIndex,
    int cardIndex,
  ) =>
      () async {
        await $.tester.pumpAndSettle();

        final frontFinder = find.byKey(
          SolverKeys.playerCardButtonFront(playerIndex, cardIndex),
        );
        final backFinder = find.byKey(
          SolverKeys.playerCardButtonBack(playerIndex, cardIndex),
        );
        await $.tester.longPress(
          frontFinder.evaluate().isNotEmpty ? frontFinder : backFinder,
        );
      };

  TAction pickCardValue(int value) =>
      () => $(SolverKeys.cardPickerValue(value)).tap();

  TAction pickCardSuit(String suit) =>
      () => $(SolverKeys.cardPickerSuit(suit)).tap();

  TAction verifyTableCardBackVisibility(int index) => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(SolverKeys.tableCardBack(index)), findsOneWidget);
      };

  TAction verifyTableCardFrontVisibility({
    required int index,
    required int value,
    required String suit,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        final cardFinder = find.byKey(SolverKeys.tableCardFront(index));
        final valueFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(SolverKeys.cardValue(value, suit)),
        );
        expect(cardFinder, findsOneWidget);
        expect(valueFinder, findsOneWidget);
      };

  TAction verifyPlayerCardBackVisibility(
    int playerIndex,
    int cardIndex,
  ) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(SolverKeys.playerCardBack(playerIndex, cardIndex)),
          findsOneWidget,
        );
      };

  TAction verifyPlayerCardFrontVisibility({
    required int playerIndex,
    required int cardIndex,
    required int value,
    required String suit,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        final cardFinder =
            find.byKey(SolverKeys.playerCardFront(playerIndex, cardIndex));
        final valueFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(SolverKeys.cardValue(value, suit)),
        );
        expect(cardFinder, findsOneWidget);
        expect(valueFinder, findsOneWidget);
      };

  TAction verifyWinnerBadgeVisibility(
    int playerIndex, {
    bool isVisible = true,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(SolverKeys.winnerBadge(playerIndex)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  c.Card? getPlayerCard(int playerIndex, int cardIndex) {
    final widget = $.tester.widget<CardFront>(
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
        await runTestActions([
          tapTableCardSlot(index),
          pickCardValue(value),
          pickCardSuit(suit)
        ])();

        await $.tester.pump(const Duration(seconds: 2));
      };

  TAction selectPlayerCard({
    required int playerIndex,
    required int cardIndex,
    required int value,
    required String suit,
  }) =>
      () async {
        await runTestActions([
          tapPlayerCardSlot(playerIndex, cardIndex),
          pickCardValue(value),
          pickCardSuit(suit)
        ])();

        await $.tester.pumpAndSettle();
      };
}
