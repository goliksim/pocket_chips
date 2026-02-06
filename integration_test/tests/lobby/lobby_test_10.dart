import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Update state after game starts
Future<void> runLobbyTest10(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  await pumpLobbyApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(players: players),
    savedPlayers: savedPlayers,
  );

  final homePage = HomePageTester(tester);
  await homePage.tapContinueButton();

  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();
  await lobbyPage.toGame();

  final gamePage = GamePageTester(tester);
  await gamePage.verifyIsVisible();
  await gamePage.startGame();

  await CommonTester.closePage(tester);
  await lobbyPage.verifyIsVisible();

  expect(find.byKey(LobbyKeys.resetLobbyButton), findsOneWidget);
  expect(find.byKey(LobbyKeys.startingStackButton), findsNothing);
  expect(find.byKey(LobbyKeys.settingsButton), findsNothing);
  await lobbyPage.verifyAddPlayerButtonVisible(false);
}
