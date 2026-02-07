import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// New game creates empty lobby
Future<void> runLobbyTest11(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  await pumpLobbyApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(
      players: players,
      dealerId: players.first.uid,
    ),
    savedPlayers: savedPlayers,
  );

  final homePage = HomePageTester(tester);
  await homePage.verifyHomePageIsVisible();

  await homePage.tapNewGameButton();
  await homePage.verifyConfirmationWindowIsVisible();
  await homePage.tapConfirmationButton();

  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();
  await lobbyPage.verifyAddPlayerButtonVisible(true);

  for (final player in players) {
    expect(find.byKey(LobbyKeys.playerCard(player.name)), findsNothing);
  }
}
