import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Add player
Future<void> runLobbyTest2(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
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
  await lobbyPage.tapAddPlayersButton();

  final playerEditor = PlayerEditorTester(tester);
  await playerEditor.verifyIsVisible();
  const newName = 'new_player';
  await playerEditor.enterName(newName);
  await playerEditor.tapConfirmButton();

  await tester.pumpAndSettle(Duration(seconds: 1));
  await lobbyPage.findPlayerWithName(newName);
}
