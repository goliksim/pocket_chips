import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class SavedPlayersPageTester {
  final WidgetTester tester;

  SavedPlayersPageTester(this.tester);

  TAction verifyIsVisible() => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(SavedPlayersKeys.dialog), findsOneWidget);
      };

  TAction usePlayerByName(String name) => () async {
        await tester.pumpAndSettle();

        final screenWidth =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final offset = Offset(screenWidth, 0);

        await tester.timedDrag(
          find.byKey(SavedPlayersKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction deletePlayerByName(String name) => () async {
        await tester.pumpAndSettle();

        final screenWidth =
            tester.view.physicalSize.width / tester.view.devicePixelRatio;
        final offset = Offset(screenWidth * -0.95, 0);

        await tester.timedDrag(
          find.byKey(SavedPlayersKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction findPlayerByName(String name) => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(SavedPlayersKeys.playerCard(name)), findsOneWidget);
      };
}
