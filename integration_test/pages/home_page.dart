import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/utils/theme/themes.dart';

class HomePageTester {
  final WidgetTester tester;

  HomePageTester(this.tester);

  Future<void> verifyHomePageIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(HomeKeys.page), findsOneWidget);
  }

  Future<void> verifyTheme(Themes theme) async {
    await tester.pumpAndSettle();

    expect(find.byKey(CommonKeys.themeKey(theme)), findsOneWidget);
  }

  Future<void> verifyIsProVersionScreen() async {
    await tester.pumpAndSettle();

    expect(find.byKey(ProVersionKeys.proVersionBlockWrapper), findsNothing);
  }

  Future<void> verifyIsNotProVersionScreen() async {
    await tester.pumpAndSettle();

    expect(find.byKey(ProVersionKeys.proVersionBlockWrapper), findsAtLeast(1));
  }

  Future<void> tapHelpButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.helpButton));
  }

  Future<void> verifyConfirmationWindowIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(CommonKeys.confirmationWindow), findsOneWidget);
  }

  Future<void> tapChangeThemeButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.themeSwapButton));
  }

  Future<void> tapContinueButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.continueButton));
  }

  Future<void> tapNewGameButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.newGameButton));
  }

  Future<void> tapSolverButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.solverButton));
  }

  Future<void> tapConfirmationButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(CommonKeys.confirmButton));
  }
}
