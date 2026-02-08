import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class LobbyPageTester {
  final WidgetTester tester;

  LobbyPageTester(this.tester);

  TAction verifyIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.page),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction tapSavedPlayersButton() => () async {
        await tester.pumpAndSettle();

        final finder = find.byKey(LobbyKeys.savedPlayersButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
      };

  TAction tapAddPlayersButton() => () async {
        await tester.pumpAndSettle();

        final finder = find.byKey(LobbyKeys.addPlayerButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
      };

  TAction tapStartingStackButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(LobbyKeys.startingStackButton));
      };

  TAction tapSettingsButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(LobbyKeys.settingsButton));
      };

  TAction toGame() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(LobbyKeys.gameButton));
      };

  TAction findPlayerWithName(String name) => () async {
        await tester.pumpAndSettle();

        expect(find.text(name), findsOneWidget);
      };

  TAction findPlayerWithAssetUrl(String assetUrl) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.userAvatarKeyByAsset(assetUrl)),
          findsOneWidget,
        );
      };

  TAction verifyPlayerBank({
    required String name,
    required int expectedBank,
  }) =>
      () async {
        await tester.pumpAndSettle();

        final cardFinder = find.byKey(LobbyKeys.playerCard(name));
        final bankFinder = find.descendant(
          of: cardFinder,
          matching: find.byKey(LobbyKeys.playerBank(expectedBank)),
        );

        expect(bankFinder, findsOneWidget);
      };

  TAction verifyAddPlayerButtonVisible(bool isVisible) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(LobbyKeys.addPlayerButton),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyDealerVisible({
    required String name,
    bool isVisible = true,
  }) =>
      () async {
        await tester.pumpAndSettle();

        final cardFinder = find.byKey(LobbyKeys.playerCard(name));
        final dealerIcon = find.descendant(
          of: cardFinder,
          matching: find.byKey(LobbyKeys.dealerIcon),
        );

        expect(dealerIcon, isVisible ? findsOneWidget : findsNothing);
      };

  TAction savePlayerByName(String name) => () async {
        await tester.pumpAndSettle();

        final card = find.byKey(LobbyKeys.playerCard(name));
        await tester.ensureVisible(card);

        final screenWidth =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final start = tester.getCenter(card);
        await tester.dragFrom(start, Offset(screenWidth, 0));
        await tester.pumpAndSettle();
      };

  TAction deletePlayerByName(String name) => () async {
        await tester.pumpAndSettle();

        final screenWidth =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final offset = Offset(screenWidth * -1, 0);

        await tester.timedDrag(
          find.byKey(LobbyKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction movePlayerUpByName(String name) => () async {
        final playerCard = find.byKey(LobbyKeys.playerCard(name));

        final start = tester.getCenter(playerCard);

        final gesture = await tester.startGesture(start);
        await tester.pump(kLongPressTimeout);
        await gesture.moveBy(const Offset(0, -200),
            timeStamp: Duration(seconds: 2));
        await gesture.up();
        await tester.pumpAndSettle();
      };

  double getPlayerYPosition(String name) {
    final playerCard = find.byKey(LobbyKeys.playerCard(name));
    return tester.getTopLeft(playerCard).dy;
  }
}
