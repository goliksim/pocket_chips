import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/theme/themes.dart';

import '../test_utils/test_action.dart';

class HomePageTester {
  final WidgetTester tester;

  HomePageTester(this.tester);

  TAction verifyHomePageIsVisible() => () async {
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byKey(HomeKeys.page), findsOneWidget);
      };

  TAction verifyTheme(Themes theme) => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(CommonKeys.themeKey(theme)), findsOneWidget);
      };

  TAction verifyIsProVersionScreen() => () async {
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byKey(ProVersionKeys.proVersionBlockWrapper), findsNothing);
      };

  TAction verifyIsNotProVersionScreen() => () async {
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(
          find.byKey(ProVersionKeys.proVersionBlockWrapper),
          findsAtLeast(1),
        );
      };

  TAction tapHelpButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.helpButton));
      };

  TAction verifyConfirmationWindowIsVisible() => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(CommonKeys.confirmationWindow), findsOneWidget);
      };

  TAction tapChangeThemeButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.themeSwapButton));
      };

  TAction tapContinueButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.continueButton));
      };

  TAction tapNewGameButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.newGameButton));
      };

  TAction tapSolverButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.solverButton));
      };

  TAction tapDonationButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(HomeKeys.donationButton));
      };

  TAction tapConfirmationButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(CommonKeys.confirmButton));
      };
}
