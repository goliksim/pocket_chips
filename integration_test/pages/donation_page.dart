import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/constants.dart';

import '../test_utils/test_action.dart';

class DonationPageTester {
  final WidgetTester tester;

  DonationPageTester(this.tester);

  TAction verifyIsVisible() => () async {
        expect(find.byKey(DonationKeys.dialog), findsOneWidget);
      };

  TAction verifyProMode({bool isPurchased = false}) => () async {
        expect(
          find.byKey(DonationKeys.item(
            id: Constants.pocketChipsPROItemKey,
            isBuyed: isPurchased,
            loaded: true,
          )),
          findsOneWidget,
        );
      };

  TAction verifyNoProMode({bool isPurchased = false}) => () async {
        expect(
          find.byKey(DonationKeys.item(
            id: Constants.pocketChipsPROItemKey,
            isBuyed: isPurchased,
            loaded: true,
          )),
          findsNothing,
        );
      };

  TAction verifyVideoAd({bool isLoaded = true}) => () async {
        expect(
          find.byKey(DonationKeys.item(
            id: Constants.videoAdItemKey,
            loaded: isLoaded,
            isBuyed: false,
          )),
          findsOneWidget,
        );
      };

  TAction verifyUnavailable() => () async {
        expect(
          find.byKey(DonationKeys.itemsUnavailable),
          findsOneWidget,
        );
      };

  TAction buyProMode({bool isPurchased = false}) => () async {
        await tester.tap(
          find.byKey(
            DonationKeys.item(
              id: Constants.pocketChipsPROItemKey,
              isBuyed: isPurchased,
              loaded: true,
            ),
          ),
        );
      };

  TAction restorePurchases({bool isPurchased = false}) => () async {
        await tester.tap(
          find.byKey(DonationKeys.restoreButton),
        );
      };

  TAction retry({bool isPurchased = false}) => () async {
        await tester.tap(
          find.byKey(DonationKeys.retryButton),
        );
      };
}
