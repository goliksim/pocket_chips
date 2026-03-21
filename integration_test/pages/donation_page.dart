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

  TAction verifyProModeItemLoaded({
    bool isPurchased = false,
    bool isLoaded = true,
  }) =>
      () async {
        expect(
          find.byKey(
            DonationKeys.item(
              id: Constants.pocketChipsPROItemKey,
              isBuyed: isPurchased,
              loaded: true,
            ),
          ),
          isLoaded ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyVideoAdItemLoaded({bool isLoaded = true}) => () async {
        expect(
          find.byKey(
            DonationKeys.item(
              id: Constants.videoAdItemKey,
              loaded: isLoaded,
              isBuyed: false,
            ),
          ),
          findsOneWidget,
        );
      };

  TAction verifyUnavailableState() => () async {
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
