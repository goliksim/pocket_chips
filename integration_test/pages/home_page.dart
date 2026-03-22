import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/theme/themes.dart';

import '../test_utils/test_action.dart';
import 'common_tester.dart';

class HomePageTester {
  final PatrolTester $;

  HomePageTester(this.$);

  TAction verifyHomePageVisibility() => () async {
        await $.tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byKey(HomeKeys.page), findsOneWidget);
      };

  TAction verifyTheme(Themes theme) => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(CommonKeys.themeKey(theme)), findsOneWidget);
      };

  TAction verifyProVersionScreen({bool isPro = true}) => () async {
        await $.tester.pumpAndSettle(const Duration(seconds: 1));

        expect(
          find.byKey(ProVersionKeys.proVersionBlockWrapper),
          isPro ? findsNothing : findsAtLeast(1),
        );
      };

  TAction openOnboarding() => () => $(HomeKeys.helpButton).tap();

  TAction verifyConfirmationWindowVisibility() => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(CommonKeys.confirmationWindow), findsOneWidget);
      };

  TAction changeTheme() =>
      () => $(find.byKey(HomeKeys.themeSwapButton)).tapPROWidget();

  TAction continueGame() => () => $(HomeKeys.continueButton).tapPROWidget();

  TAction newGame() => () => $(HomeKeys.newGameButton).tapAnimated();

  TAction openSolver() => () => $(HomeKeys.solverButton).tapPROWidget();

  TAction openDonationPage() => () => $(HomeKeys.donationButton).tap(
        settlePolicy: SettlePolicy.noSettle,
      );

  TAction confirmConfirmationDialog() =>
      () => $(CommonKeys.confirmButton).tap();
}
