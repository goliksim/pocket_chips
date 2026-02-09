import 'package:patrol_finders/patrol_finders.dart';

import '../../pages/home_page.dart';
import '../../pages/solver_page.dart';
import '../../solver_test.mocks.dart';
import '../../test_utils/test_action.dart';
import 'solver_test_utils.dart';

/// [SolverTest]
/// Add card, remove card, and prevent duplicate card
Future<void> runSolverTest1(
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
      // Add card to table
      solverPage.selectTableCard(index: 0, value: 14, suit: 's'),
      solverPage.verifyTableCardFrontVisibility(
        index: 0,
        value: 14,
        suit: 's',
      ),
      // Add another card to table
      solverPage.selectTableCard(index: 1, value: 13, suit: 'c'),
      solverPage.verifyTableCardFrontVisibility(
        index: 1,
        value: 13,
        suit: 'c',
      ),
      // Try to add duplicate card to table
      solverPage.selectTableCard(index: 2, value: 14, suit: 's'),
      solverPage.verifyTableCardBackVisibility(2),
      // Remove card from table
      solverPage.longPressTableCardSlot(0),
      solverPage.verifyTableCardBackVisibility(0),
    ],
  )();
}
