import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/lobby_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo after Lobby reset returns previous state
Future<void> runGameTest10(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  await pumpGameApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(
      players: players,
      dealerId: players.first.uid,
    ),
    savedPlayers: savedPlayers,
  );

  await openGamePage(tester);
  final gamePage = GamePageTester(tester);

  await gamePage.startGame();
  await gamePage.tapCallButton();
  await gamePage.verifyCurrentPlayer(players.last.name);

  await CommonTester.closePage(tester);
  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();

  await tester.tap(find.byKey(LobbyKeys.resetLobbyButton));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(CommonKeys.confirmButton));
  await tester.pumpAndSettle();

  await lobbyPage.toGame();
  await gamePage.verifyIsVisible();
  await gamePage.verifyUndoButtonIsVisible();

  await gamePage.tapUndoActionButton();
  await gamePage.verifyCurrentPlayer(players.first.name);
}
