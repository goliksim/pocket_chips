import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// New game creates empty lobby
Future<void> runLobbyTest11(
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
      lobbyState: buildLobbyState(
        players: players,
        dealerId: players.first.uid,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  TAction verifyPlayersNotInLobby() => () async {
        for (final player in players) {
          expect(find.byKey(LobbyKeys.playerCard(player.name)), findsNothing);
        }
      };

  // Run test actions
  await runTestActions(
    [
      // Create new game, verify lobby is empty
      homePage.verifyHomePageVisibility(),
      homePage.newGame(),
      homePage.verifyConfirmationWindowVisibility(),
      homePage.confirmConfirmationDialog(),
      lobbyPage.verifyVisibility(),
      lobbyPage.verifyAddPlayerButtonVisibility(true),
      verifyPlayersNotInLobby(),
    ],
  )();
}
