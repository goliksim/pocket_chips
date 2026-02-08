import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class ProVersionOfferPageTester {
  final WidgetTester tester;

  ProVersionOfferPageTester(this.tester);

  TAction tapBuyPROButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ProVersionKeys.proVersionAvailableButton));
      };

  TAction tapCloseButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(ProVersionKeys.proVersionCloseButton));
      };

  TAction verifyOfferIsVisible({bool isVisible = true}) => () async {
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionOfferDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyProVersionIsPurchased() => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionPurshasedButton),
          findsOneWidget,
        );
      };

  TAction verifyProVersionIsAvailable() => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionAvailableButton),
          findsOneWidget,
        );
      };

  TAction verifyProVersionIsNotAvailable() => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(ProVersionKeys.proVersionNotAvailableButton),
          findsOneWidget,
        );
      };
}
