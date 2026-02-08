import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Max players
Future<void> runLobbyTest7(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(maxPlayerCount);
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
      homePage.tapContinueButton(),
      lobbyPage.verifyIsVisible(),
      // Verify max players reached and add player button is not visible
      lobbyPage.verifyAddPlayerButtonVisible(false),
    ],
  )();
}
