import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/constants.dart';

import '../test_utils/test_action.dart';

class DonationPageTester {
  final PatrolTester $;

  DonationPageTester(this.$);

  TAction verifyVisibility() =>
      () async => expect(find.byKey(DonationKeys.dialog), findsOneWidget);

  TAction verifyProModeItemExist({
    bool isPurchased = false,
    bool exist = true,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(DonationKeys.item(
            id: Constants.pocketChipsPROItemKey,
            isBuyed: isPurchased,
            loaded: true,
          )),
          exist ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyVideoAdItemExist({bool isLoaded = true}) => () async {
        if (isLoaded) {
          await $.tester.pumpAndSettle();
        }

        expect(
          find.byKey(DonationKeys.item(
            id: Constants.videoAdItemKey,
            loaded: isLoaded,
            isBuyed: false,
          )),
          findsOneWidget,
        );
      };

  TAction verifyUnavailableState() => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(DonationKeys.itemsUnavailable),
          findsOneWidget,
        );
      };

  TAction buyProMode({bool isPurchased = false}) => () => $(
        DonationKeys.item(
          id: Constants.pocketChipsPROItemKey,
          isBuyed: isPurchased,
          loaded: true,
        ),
      ).tap();

  TAction restorePurchases({bool isPurchased = false}) =>
      () => $(DonationKeys.restoreButton).tap();

  TAction retry({bool isPurchased = false}) =>
      () => $(DonationKeys.retryButton).tap();
}
