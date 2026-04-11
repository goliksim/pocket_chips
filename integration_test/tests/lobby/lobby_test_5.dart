import 'package:flutter_test/flutter_test.dart';
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
/// Add saved player from list
Future<void> runLobbyTest5(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
  final savedPlayer = PlayerModel(
    uid: 'saved_uid',
    name: 'saved_name',
    assetUrl: players.first.assetUrl,
  );
  final savedPlayers = <PlayerModel>[savedPlayer];

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
      // Open saved players, add player from saved players list, verify it's added to the lobby
      lobbyPage.openSavedPlayersDialog(),
      savedPlayersPage.verifyVisibility(),
      savedPlayersPage.usePlayerByName(savedPlayer.name),
      CommonTester.closeDialog(tester),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(savedPlayer.name),
    ],
  )();
}
