import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class ProVersionOfferPageTester {
  final PatrolTester $;

  ProVersionOfferPageTester(this.$);

  TAction buyPRO() => () => $(ProVersionKeys.proVersionAvailableButton).tap();

  TAction closeOfferDialog() =>
      () => $(ProVersionKeys.proVersionCloseButton).tap();

  TAction verifyOfferVisibility({bool isVisible = true}) => () async {
        await $.tester.pump(const Duration(seconds: 1));
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionOfferDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyProVersionIsPurchased() => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionPurshasedButton),
          findsOneWidget,
        );
      };

  TAction verifyProVersionIsAvailable() => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionAvailableButton),
          findsOneWidget,
        );
      };

  TAction verifyProVersionIsNotAvailable() => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionNotAvailableButton),
          findsOneWidget,
        );
      };
}
