import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class SavedPlayersPageTester {
  final WidgetTester tester;

  SavedPlayersPageTester(this.tester);

  Future<void> verifyIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(SavedPlayersKeys.dialog), findsOneWidget);
  }

  Future<void> usePlayerByName(String name) async {
    await tester.pumpAndSettle();

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final offset = Offset(screenWidth, 0);

    await tester.timedDrag(
      find.byKey(SavedPlayersKeys.playerCard(name)),
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
      find.byKey(SavedPlayersKeys.playerCard(name)),
      offset,
      Duration(seconds: 2),
    );
  }

  Future<void> findPlayerByName(String name) async {
    await tester.pumpAndSettle();

    expect(find.byKey(SavedPlayersKeys.playerCard(name)), findsOneWidget);
  }
}
