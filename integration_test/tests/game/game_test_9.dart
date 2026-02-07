import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_tests.mocks.dart';
import '../../pages/game_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo after winner selection with side pot
Future<void> runGameTest9(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(3);
  final savedPlayers = <PlayerModel>[];
  final banks = {
    players[0].uid: 10,
    players[1].uid: 20,
    players[2].uid: 20,
  };

  await pumpGameApp(
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
  );

  await openGamePage(tester);
  final gamePage = GamePageTester(tester);

  await gamePage.startGame();
  await gamePage.tapAllInButton();
  await gamePage.tapAllInButton();

  await gamePage.verifyWinnerChoiceDialogVisible();
  await gamePage.selectWinner(players.first.uid);
  await gamePage.confirmWinnerChoice();

  await gamePage.verifyWinnerChoiceDialogVisible();
  await gamePage.selectWinner(players[1].uid);
  await gamePage.confirmWinnerChoice();

  await gamePage.verifyWinnerChoiceDialogVisible(isVisible: false);
  await gamePage.tapUndoActionButton();

  await gamePage.verifyWinnerChoiceDialogVisible(isVisible: false);
}
