import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo after restart from breakdown should not show winner effect again
Future<void> runGameTest12(
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

  await runTestActions(
    [
      openGamePage(tester),
      gamePage.startGame(),
      gamePage.fold(),
      gamePage.verifyWinnerDialogVisibility(),
      gamePage.tapWinnerDialog(),
      gamePage.verifyWinnerDialogVisibility(isVisible: false),
      gamePage.verifyGameStatus(GameStatusEnum.gameBreak),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.undoLastAction(),
      gamePage.verifyGameStatus(GameStatusEnum.gameBreak),
      gamePage.verifyWinnerDialogVisibility(isVisible: false),
    ],
  )();
}
