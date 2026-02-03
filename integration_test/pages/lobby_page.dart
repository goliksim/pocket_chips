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

    await tester.tap(find.byKey(LobbyKeys.savedPlayersButton));
  }

  Future<void> tapAddPlayersButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LobbyKeys.addPlayerButton));
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

  Future<void> savePlayerByName(String name) async {
    await tester.pumpAndSettle();

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final offset = Offset(screenWidth * 0.95, 0);

    await tester.timedDrag(
      find.byKey(LobbyKeys.playerCard(name)),
      offset,
      Duration(seconds: 2),
    );
  }

  Future<void> deletePlayerByName(String name) async {
    await tester.pumpAndSettle();

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final offset = Offset(screenWidth * -0.95, 0);

    await tester.timedDrag(
      find.byKey(LobbyKeys.playerCard(name)),
      offset,
      Duration(seconds: 10),
    );
  }
}
