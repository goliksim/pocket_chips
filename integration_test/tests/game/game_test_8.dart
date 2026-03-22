import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo action returns to previous state
Future<void> runGameTest8(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final gamePage = GamePageTester(tester);

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
      // Verify undo button appears after action and can be used to return to previous state
      gamePage.verifyUndoButtonVisibility(),
      gamePage.undoLastAction(),
      // Verify game state returned to pre-action state
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
      gamePage.verifyUndoButtonVisibility(isVisible: false),
    ],
  )();
}
