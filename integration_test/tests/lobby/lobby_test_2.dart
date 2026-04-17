import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Add player
Future<void> runLobbyTest2(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final playerEditor = PlayerEditorTester(tester);
  const newName = 'new_player';

  await runAction(
    pumpLobbyApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(players: players),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open lobby page
      homePage.continueGame(),
      lobbyPage.verifyVisibility(),
      // Add new player, verify it's added to the list
      lobbyPage.addPlayer(),
      playerEditor.verifyVisibility(),
      playerEditor.enterName(newName),
      playerEditor.confirmEditingAndExit(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(newName),
    ],
  )();
}
