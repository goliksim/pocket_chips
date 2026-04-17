import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/saved_players_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Save player
Future<void> runLobbyTest3(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final savedPlayersPage = SavedPlayersPageTester(tester);

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
      // Save player, verify it's in saved players list
      lobbyPage.savePlayerByName(players.first.name),
      lobbyPage.openSavedPlayersDialog(),
      savedPlayersPage.verifyVisibility(),
      savedPlayersPage.findPlayerByName(players.first.name),
      CommonTester.closeDialog(tester),
    ],
  )();
}
