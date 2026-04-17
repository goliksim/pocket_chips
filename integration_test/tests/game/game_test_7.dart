import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Side pot: WinnerChoiceWindow appears twice
Future<void> runGameTest7(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(3);
  final savedPlayers = <PlayerModel>[];
  final banks = {
    players[0].uid: 10,
    players[1].uid: 20,
    players[2].uid: 20,
  };

  final gamePage = GamePageTester(tester);

  await runAction(
    pumpGameApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(
        players: players,
        banks: banks,
        bank: 20,
        smallBlind: 10,
        dealerId: players.first.uid,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open game page and start game, all players go all in,
      // Verify winner choice dialog appears for main pot and side pot
      openGamePage(tester),
      gamePage.startGame(),
      gamePage.allIn(),
      gamePage.allIn(),
      gamePage.verifyWinnerChoiceDialogVisibility(),
      gamePage.selectWinner(players.first.uid),
      gamePage.confirmWinnerChoice(),
      gamePage.verifyWinnerChoiceDialogVisibility(),
      gamePage.selectWinner(players[1].uid),
      gamePage.confirmWinnerChoice(),
      // Verify winner choice dialog does not appear again after close and new game
      gamePage.verifyWinnerChoiceDialogVisibility(isVisible: false),
      gamePage.startGame(),
      gamePage.verifyWinnerChoiceDialogVisibility(isVisible: false),
    ],
  )();
}
