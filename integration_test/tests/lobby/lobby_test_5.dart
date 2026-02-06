import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/saved_players_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Add saved player from list
Future<void> runLobbyTest5(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
  final savedPlayer = PlayerModel(
    uid: 'saved_uid',
    name: 'saved_name',
    assetUrl: players.first.assetUrl,
  );
  final savedPlayers = <PlayerModel>[savedPlayer];

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
  await lobbyPage.tapSavedPlayersButton();

  final savedPlayersPage = SavedPlayersPageTester(tester);
  await savedPlayersPage.verifyIsVisible();
  await savedPlayersPage.usePlayerByName(savedPlayer.name);
  await CommonTester.closeDialog(tester);

  await tester.pumpAndSettle(Duration(seconds: 1));
  await lobbyPage.findPlayerWithName(savedPlayer.name);
}
