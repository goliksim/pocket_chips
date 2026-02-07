import 'package:flutter_test/flutter_test.dart';

import '../../pages/home_page.dart';
import '../../pages/solver_page.dart';
import '../../solver_tests.mocks.dart';
import 'solver_test_utils.dart';

/// [SolverTest]
/// Add card, remove card, and prevent duplicate card
Future<void> runSolverTest1(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  await pumpHomeApp(
    tester: tester,
    repository: repository,
  );

  final homePage = HomePageTester(tester);
  await homePage.verifyHomePageIsVisible();
  await homePage.tapSolverButton();

  final solverPage = SolverPageTester(tester);
  await solverPage.verifyIsVisible();

  await solverPage.selectTableCard(index: 0, value: 14, suit: 's');
  await solverPage.verifyTableCardFrontVisible(index: 0, value: 14, suit: 's');

  await solverPage.selectTableCard(index: 1, value: 13, suit: 'c');
  await solverPage.verifyTableCardFrontVisible(index: 1, value: 13, suit: 'c');

  await solverPage.selectTableCard(index: 2, value: 14, suit: 's');
  await solverPage.verifyTableCardBackVisible(2);

  await solverPage.longPressTableCardSlot(0);
  await solverPage.verifyTableCardBackVisible(0);
}
