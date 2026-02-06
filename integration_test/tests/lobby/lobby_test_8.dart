import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Reorder players
Future<void> runLobbyTest8(
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

  final firstCard = find.byKey(LobbyKeys.playerCard(players.first.name));
  final lastCard = find.byKey(LobbyKeys.playerCard(players.last.name));

  final firstDyBefore = tester.getTopLeft(firstCard).dy;
  final lastDyBefore = tester.getTopLeft(lastCard).dy;

  expect(lastDyBefore, greaterThan(firstDyBefore));

  final start = tester.getCenter(lastCard);

  final gesture = await tester.startGesture(start);
  await tester.pump(kLongPressTimeout);
  await gesture.moveBy(const Offset(0, -200), timeStamp: Duration(seconds: 2));
  await gesture.up();
  await tester.pumpAndSettle();

  final firstDyAfter = tester.getTopLeft(firstCard).dy;
  final lastDyAfter = tester.getTopLeft(lastCard).dy;

  expect(lastDyAfter, lessThan(firstDyAfter));
}
