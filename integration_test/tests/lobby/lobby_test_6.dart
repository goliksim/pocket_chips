import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/saved_players_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Delete saved player
Future<void> runLobbyTest6(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(1);
  final savedPlayers = buildPlayers(2, startIndex: 100, namePrefix: 'saved');

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

  final nameToDelete = savedPlayers.first.name;
  await savedPlayersPage.deletePlayerByName(nameToDelete);

  await tester.pumpAndSettle();
  await tester.tap(find.byKey(CommonKeys.confirmButton));
  await tester.pumpAndSettle(Duration(seconds: 1));

  expect(
    find.byKey(SavedPlayersKeys.playerCard(nameToDelete)),
    findsNothing,
  );
}
