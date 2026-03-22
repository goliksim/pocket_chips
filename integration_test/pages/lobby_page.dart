import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';
import 'common_tester.dart';

class LobbyPageTester {
  final PatrolTester $;

  LobbyPageTester(this.$);

  TAction verifyVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.page),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction openSavedPlayersDialog() =>
      () => $(LobbyKeys.savedPlayersButton).tapPROWidget();

  TAction addPlayer() => () => $(LobbyKeys.addPlayerButton).tapPROWidget();

  TAction openInitialStackEditor() =>
      () => $(LobbyKeys.startingStackButton).tap();

  TAction openSettings() => () => $(LobbyKeys.settingsButton).tap();

  TAction toGame() => () => $(LobbyKeys.gameButton).tap();

  TAction findPlayerWithName(String name) => () async {
        await $.tester.pumpAndSettle();

        expect(find.text(name), findsOneWidget);
      };

  TAction findPlayerWithAssetUrl(String assetUrl) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.userAvatarKeyByAsset(assetUrl)),
          findsOneWidget,
        );
      };

  TAction verifyPlayerBankValue({
    required String name,
    required int expectedBank,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        final cardFinder = find.byKey(LobbyKeys.playerCard(name));
        final bankFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(LobbyKeys.playerBank(expectedBank)),
        );

        expect(bankFinder, findsOneWidget);
      };

  TAction verifyAddPlayerButtonVisibility(bool isVisible) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.addPlayerButton),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyDealerVisibility({
    required String name,
    bool isVisible = true,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        final cardFinder = find.byKey(LobbyKeys.playerCard(name));
        final dealerIcon = find.descendant(
          of: cardFinder,
          matching: find.byKey(LobbyKeys.dealerIcon),
        );

        expect(dealerIcon, isVisible ? findsOneWidget : findsNothing);
      };

  TAction savePlayerByName(String name) => () async {
        await $.tester.pumpAndSettle();

        final card = find.byKey(LobbyKeys.playerCard(name));
        await $.tester.ensureVisible(card);

        final screenWidth =
            $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio;
        final start = $.tester.getCenter(card);
        await $.tester.dragFrom(start, Offset(screenWidth, 0));
        await $.tester.pumpAndSettle();
      };

  TAction deletePlayerByName(String name) => () async {
        await $.tester.pumpAndSettle();

        final screenWidth =
            $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio;
        final offset = Offset(screenWidth * -1, 0);

        await $.tester.timedDrag(
          find.byKey(LobbyKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction movePlayerUpByName(String name) => () async {
        final playerCard = find.byKey(LobbyKeys.playerCard(name));

        final start = $.tester.getCenter(playerCard);

        final gesture = await $.tester.startGesture(start);
        await $.tester.pump(kLongPressTimeout);
        await gesture.moveBy(const Offset(0, -200),
            timeStamp: Duration(seconds: 2));
        await gesture.up();
        await $.tester.pumpAndSettle();
      };

  double getPlayerYPosition(String name) {
    final playerCard = find.byKey(LobbyKeys.playerCard(name));
    return $.tester.getTopLeft(playerCard).dy;
  }
}
