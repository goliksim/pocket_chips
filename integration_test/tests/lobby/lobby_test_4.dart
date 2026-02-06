import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Delete player
Future<void> runLobbyTest4(
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

  await lobbyPage.deletePlayerByName(players.first.name);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(CommonKeys.confirmButton));

  await tester.pumpAndSettle(Duration(seconds: 1));
  expect(find.text(players.first.name), findsNothing);
}
