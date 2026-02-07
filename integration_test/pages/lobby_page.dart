import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class LobbyPageTester {
  final WidgetTester tester;

  LobbyPageTester(this.tester);

  Future<void> verifyIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(LobbyKeys.page),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> tapSavedPlayersButton() async {
    await tester.pumpAndSettle();

    final finder = find.byKey(LobbyKeys.savedPlayersButton);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
  }

  Future<void> tapAddPlayersButton() async {
    await tester.pumpAndSettle();

    final finder = find.byKey(LobbyKeys.addPlayerButton);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
  }

  Future<void> tapStartingStackButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LobbyKeys.startingStackButton));
  }

  Future<void> tapSettingsButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LobbyKeys.settingsButton));
  }

  Future<void> toGame() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LobbyKeys.gameButton));
  }

  Future<void> findPlayerWithName(String name) async {
    await tester.pumpAndSettle();

    expect(find.text(name), findsOneWidget);
  }

  Future<void> findPlayerWithAssetUrl(String assetUrl) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(LobbyKeys.userAvatarKeyByAsset(assetUrl)),
      findsOneWidget,
    );
  }

  Future<void> verifyPlayerBank({
    required String name,
    required int expectedBank,
  }) async {
    await tester.pumpAndSettle();

    final cardFinder = find.byKey(LobbyKeys.playerCard(name));
    final bankFinder = find.descendant(
      of: cardFinder,
      matching: find.byKey(LobbyKeys.playerBank(expectedBank)),
    );

    expect(bankFinder, findsOneWidget);
  }

  Future<void> verifyAddPlayerButtonVisible(bool isVisible) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(LobbyKeys.addPlayerButton),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyDealerVisible({
    required String name,
    bool isVisible = true,
  }) async {
    await tester.pumpAndSettle();

    final cardFinder = find.byKey(LobbyKeys.playerCard(name));
    final dealerIcon = find.descendant(
      of: cardFinder,
      matching: find.byKey(LobbyKeys.dealerIcon),
    );

    expect(dealerIcon, isVisible ? findsOneWidget : findsNothing);
  }

  Future<void> savePlayerByName(String name) async {
    await tester.pumpAndSettle();

    final card = find.byKey(LobbyKeys.playerCard(name));
    await tester.ensureVisible(card);

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final start = tester.getCenter(card);
    await tester.dragFrom(start, Offset(screenWidth, 0));
    await tester.pumpAndSettle();
  }

  Future<void> deletePlayerByName(String name) async {
    await tester.pumpAndSettle();

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final offset = Offset(screenWidth * -1, 0);

    await tester.timedDrag(
      find.byKey(LobbyKeys.playerCard(name)),
      offset,
      Duration(seconds: 2),
    );
  }
}
