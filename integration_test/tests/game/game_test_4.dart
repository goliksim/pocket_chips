import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// WinnerPage appears once and not again after reopen/new game
Future<void> runGameTest4(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final gamePage = GamePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);

  await runAction(
    pumpGameApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(
        players: players,
        dealerId: players.first.uid,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open game page and start game
      openGamePage(tester),
      gamePage.startGame(),
      // Verify winner dialog appears after fold and can be closed
      gamePage.fold(),
      gamePage.verifyWinnerDialogVisibility(),
      gamePage.tapWinnerDialog(),
      gamePage.verifyWinnerDialogVisibility(isVisible: false),
      // Verify winner dialog does not appear again after close and new game
      CommonTester.closePage(tester),
      lobbyPage.verifyVisibility(),
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.verifyWinnerDialogVisibility(isVisible: false),
      gamePage.startGame(),
      gamePage.verifyWinnerDialogVisibility(isVisible: false),
    ],
  )();
}
