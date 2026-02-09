import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/saved_players_page.dart';
import '../../test_utils/test_action.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Delete saved player
Future<void> runLobbyTest6(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
  final savedPlayers = buildPlayers(2, startIndex: 100, namePrefix: 'saved');

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final savedPlayersPage = SavedPlayersPageTester(tester);
  final nameToDelete = savedPlayers.first.name;
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
      // Open saved players, delete player from saved players list, verify it's deleted
      lobbyPage.openSavedPlayersDialog(),
      savedPlayersPage.verifyVisibility(),
      savedPlayersPage.deletePlayerByName(nameToDelete),
      () => tester(CommonKeys.confirmButton).tap(),
      () async => expect(
            find.byKey(SavedPlayersKeys.playerCard(nameToDelete)),
            findsNothing,
          ),
    ],
  )();
}
