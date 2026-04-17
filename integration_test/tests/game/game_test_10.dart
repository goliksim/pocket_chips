import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo after Lobby reset returns previous state
Future<void> runGameTest10(
  PatrolTester tester,
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
      gamePage.call(),
      gamePage.verifyCurrentPlayer(players.last.name), // BB player
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      CommonTester.closePage(tester),
      lobbyPage.verifyVisibility(),
      () => tester(LobbyKeys.resetLobbyButton).tap(),
      () => tester.pumpAndSettle(),
      () => tester(CommonKeys.confirmButton).tap(),
      () => tester.pumpAndSettle(),
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
      gamePage.verifyUndoButtonVisibility(),
      gamePage.undoLastAction(),
      gamePage.verifyCurrentPlayer(players.last.name), // BB player
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
    ],
  )();
}
