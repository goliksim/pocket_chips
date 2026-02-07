import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Max players
Future<void> runLobbyTest7(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(10);
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
  await lobbyPage.verifyAddPlayerButtonVisible(false);
}
