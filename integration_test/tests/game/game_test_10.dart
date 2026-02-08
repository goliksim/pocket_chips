import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo after Lobby reset returns previous state
Future<void> runGameTest10(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final gamePage = GamePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);

  await runAction(
    pumpGameApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(
        players: players,
        dealerId: players.first.uid,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open game page and start game
      openGamePage(tester),
      gamePage.startGame(),
      // Verify current player is second player
      // And current player can be changed to first player after undo, even after lobby reset
      gamePage.tapCallButton(),
      gamePage.verifyCurrentPlayer(players.last.name),
      CommonTester.closePage(tester),
      lobbyPage.verifyIsVisible(),
      () => tester.tap(find.byKey(LobbyKeys.resetLobbyButton)),
      () => tester.pumpAndSettle(),
      () => tester.tap(find.byKey(CommonKeys.confirmButton)),
      () => tester.pumpAndSettle(),
      lobbyPage.toGame(),
      gamePage.verifyIsVisible(),
      gamePage.verifyUndoButtonIsVisible(),
      gamePage.tapUndoActionButton(),
      gamePage.verifyCurrentPlayer(players.first.name),
    ],
  )();
}
