import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// WinnerChoiceWindow does not close by system back button
Future<void> runGameTest5(
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
        bank: 200,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  await runTestActions(
    [
      openGamePage(tester),
      gamePage.startGame(),
      gamePage.raise(),
      () => tester.pump(const Duration(seconds: 1)),
      gamePage.dragRaiseSliderToMax(),
      gamePage.confirmRaise(),
      gamePage.allIn(),
      gamePage.verifyWinnerChoiceDialogVisibility(),
      CommonTester.systemCloseDialog(tester),
      () => tester.pumpAndSettle(),
      gamePage.verifyWinnerChoiceDialogVisibility()
    ],
  )();
}
