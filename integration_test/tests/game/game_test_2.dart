import 'package:patrol_finders/patrol_finders.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/player_editor_page.dart';
import '../../pages/saved_players_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Add new player and saved player from table + max players checks
Future<void> runGameTest2(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(8);
  final savedPlayers = buildPlayers(2, namePrefix: 'saved');

  final gamePage = GamePageTester(tester);
  final playerEditor = PlayerEditorTester(tester);
  final savedPage = SavedPlayersPageTester(tester);

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
      // Open game page
      openGamePage(tester),
      gamePage.verifyVisibility(),
      // Add new player
      gamePage.addNewPlayer(),
      playerEditor.verifyVisibility(),
      playerEditor.enterName('new_1'),
      playerEditor.enterBank('5000'),
      playerEditor.confirmEditingAndExit(),
      // Verify new player added to table
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      gamePage.verifyPlayerCard('new_1'),
      // Add saved player
      gamePage.openSavedList(),
      savedPage.verifyVisibility(),
      savedPage.usePlayerByName(savedPlayers.first.name),
      savedPage.usePlayerByName(savedPlayers.last.name),
      CommonTester.closeDialog(tester),
      // Verify only 1 saved players added to table
      () => tester.pumpAndSettle(),
      gamePage.verifyPlayerCard(savedPlayers.first.name),
      gamePage.verifyPlayerCard(savedPlayers.last.name, isVisible: false),
      gamePage.verifyAddMainButtonVisibility(false)
    ],
  )();
}
