import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class SavedPlayersPageTester {
  final PatrolTester $;

  SavedPlayersPageTester(this.$);

  TAction verifyVisibility() => () async {
        await $.pumpAndSettle();

        expect(find.byKey(SavedPlayersKeys.dialog), findsOneWidget);
      };

  TAction usePlayerByName(String name) => () async {
        await $.pumpAndSettle();

        final screenWidth =
            $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio;
        final offset = Offset(screenWidth, 0);

        await $.tester.timedDrag(
          find.byKey(SavedPlayersKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction deletePlayerByName(String name) => () async {
        await $.pumpAndSettle();

        final screenWidth =
            $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio;
        final offset = Offset(screenWidth * -0.95, 0);

        await $.tester.timedDrag(
          find.byKey(SavedPlayersKeys.playerCard(name)),
          offset,
          const Duration(seconds: 2),
        );
      };

  TAction findPlayerByName(String name) => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(SavedPlayersKeys.playerCard(name)), findsOneWidget);
      };
}
