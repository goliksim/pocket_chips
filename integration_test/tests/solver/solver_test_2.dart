import 'package:flutter_test/flutter_test.dart';

import '../../pages/home_page.dart';
import '../../pages/solver_page.dart';
import '../../solver_test.mocks.dart';
import 'solver_test_utils.dart';

/// [SolverTest]
/// Winner rendering in solver
Future<void> runSolverTest2(
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

  await solverPage.selectTableCard(index: 0, value: 2, suit: 'c');
  await solverPage.selectTableCard(index: 1, value: 3, suit: 'd');
  await solverPage.selectTableCard(index: 2, value: 4, suit: 'h');
  await solverPage.selectTableCard(index: 3, value: 5, suit: 's');
  await solverPage.selectTableCard(index: 4, value: 9, suit: 'c');

  await solverPage.selectPlayerCard(
    playerIndex: 0,
    cardIndex: 0,
    value: 14,
    suit: 's',
  );
  await solverPage.selectPlayerCard(
    playerIndex: 0,
    cardIndex: 1,
    value: 14,
    suit: 'h',
  );

  await solverPage.selectPlayerCard(
    playerIndex: 1,
    cardIndex: 0,
    value: 13,
    suit: 's',
  );
  await solverPage.selectPlayerCard(
    playerIndex: 1,
    cardIndex: 1,
    value: 13,
    suit: 'h',
  );

  await tester.pump(Duration(seconds: 1));
  await solverPage.verifyWinnerBadgeVisible(0);
  await solverPage.verifyWinnerBadgeVisible(1, isVisible: false);
}
