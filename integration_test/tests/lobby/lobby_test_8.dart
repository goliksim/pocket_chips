import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Reorder players
Future<void> runLobbyTest8(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);

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
      // Move last player to the top, verify it's moved
      lobbyPage.movePlayerUpByName(players.last.name),
      () async {
        final firstDyAfter = lobbyPage.getPlayerYPosition(players.first.name);
        final lastDyAfter = lobbyPage.getPlayerYPosition(players.last.name);

        expect(lastDyAfter, lessThan(firstDyAfter));
      }
    ],
  )();
}
