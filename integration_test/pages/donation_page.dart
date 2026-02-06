import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/constants.dart';

class DonationPageTester {
  final WidgetTester tester;

  DonationPageTester(this.tester);

  Future<void> verifyIsVisible() async {
    expect(find.byKey(DonationKeys.dialog), findsOneWidget);
  }

  Future<void> verifyProMode({bool isPurchased = false}) async {
    expect(
      find.byKey(DonationKeys.item(
        id: Constants.pocketChipsPROItemKey,
        isBuyed: isPurchased,
        loaded: true,
      )),
      findsOneWidget,
    );
  }

  Future<void> verifyNoProMode({bool isPurchased = false}) async {
    expect(
      find.byKey(DonationKeys.item(
        id: Constants.pocketChipsPROItemKey,
        isBuyed: isPurchased,
        loaded: true,
      )),
      findsNothing,
    );
  }

  Future<void> verifyVideoAd({bool isLoaded = true}) async {
    expect(
      find.byKey(DonationKeys.item(
        id: Constants.videoAdItemKey,
        loaded: isLoaded,
        isBuyed: false,
      )),
      findsOneWidget,
    );
  }

  Future<void> verifyUnavailable() async {
    expect(
      find.byKey(DonationKeys.itemsUnavailable),
      findsOneWidget,
    );
  }

  Future<void> buyProMode({bool isPurchased = false}) async {
    await tester.tap(
      find.byKey(
        DonationKeys.item(
          id: Constants.pocketChipsPROItemKey,
          isBuyed: isPurchased,
          loaded: true,
        ),
      ),
    );
  }

  Future<void> restorePurchases({bool isPurchased = false}) async {
    await tester.tap(
      find.byKey(DonationKeys.restoreButton),
    );
  }

  Future<void> retry({bool isPurchased = false}) async {
    await tester.tap(
      find.byKey(DonationKeys.retryButton),
    );
  }
}
