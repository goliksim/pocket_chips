import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Update state after game starts
Future<void> runLobbyTest10(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final gamePage = GamePageTester(tester);
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
      // Start game, verify lobby state is updated after game ends
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.startGame(),
      CommonTester.closePage(tester),
      lobbyPage.verifyVisibility(),
      lobbyPage.verifyAddPlayerButtonVisibility(false),
      () async =>
          expect(find.byKey(LobbyKeys.resetLobbyButton), findsOneWidget),
      () async =>
          expect(find.byKey(LobbyKeys.startingStackButton), findsNothing),
      () async => expect(find.byKey(LobbyKeys.settingsButton), findsNothing),
    ],
  )();
}
