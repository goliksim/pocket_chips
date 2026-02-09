import 'package:patrol_finders/patrol_finders.dart';

import '../../pages/home_page.dart';
import '../../pages/solver_page.dart';
import '../../solver_test.mocks.dart';
import '../../test_utils/test_action.dart';
import 'solver_test_utils.dart';

/// [SolverTest]
/// Winner rendering in solver
Future<void> runSolverTest2(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final homePage = HomePageTester(tester);
  final solverPage = SolverPageTester(tester);

  await runAction(
    pumpHomeApp(
      tester: tester,
      repository: repository,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open solver page
      homePage.verifyHomePageVisibility(),
      homePage.openSolver(),
      solverPage.verifyVisibility(),
      // Add cards to table and players
      solverPage.selectTableCard(index: 0, value: 2, suit: 'c'),
      solverPage.selectTableCard(index: 1, value: 3, suit: 'd'),
      solverPage.selectTableCard(index: 2, value: 4, suit: 'h'),
      solverPage.selectTableCard(index: 3, value: 5, suit: 's'),
      solverPage.selectTableCard(index: 4, value: 9, suit: 'c'),
      solverPage.selectPlayerCard(
        playerIndex: 0,
        cardIndex: 0,
        value: 14,
        suit: 's',
      ),
      solverPage.selectPlayerCard(
        playerIndex: 0,
        cardIndex: 1,
        value: 14,
        suit: 'h',
      ),
      solverPage.selectPlayerCard(
        playerIndex: 1,
        cardIndex: 0,
        value: 13,
        suit: 's',
      ),
      solverPage.selectPlayerCard(
        playerIndex: 1,
        cardIndex: 1,
        value: 13,
        suit: 'h',
      ),
      // Verify winner badge is shown for player 1
      () => tester.pump(const Duration(seconds: 1)),
      solverPage.verifyWinnerBadgeVisibility(0),
      solverPage.verifyWinnerBadgeVisibility(1, isVisible: false),
    ],
  )();
}
