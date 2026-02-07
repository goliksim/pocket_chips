import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class ProVersionOfferPageTester {
  final WidgetTester tester;

  ProVersionOfferPageTester(this.tester);

  Future<void> tapBuyPROButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ProVersionKeys.proVersionAvailableButton));
  }

  Future<void> tapCloseButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ProVersionKeys.proVersionCloseButton));
  }

  Future<void> verifyOfferIsVisible({bool isVisible = true}) async {
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(
      find.byKey(ProVersionKeys.proVersionOfferDialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyProVersionIsPurchased() async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(ProVersionKeys.proVersionPurshasedButton),
      findsOneWidget,
    );
  }

  Future<void> verifyProVersionIsAvailable() async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(ProVersionKeys.proVersionAvailableButton),
      findsOneWidget,
    );
  }

  Future<void> verifyProVersionIsNotAvailable() async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(ProVersionKeys.proVersionNotAvailableButton),
      findsOneWidget,
    );
  }
}
