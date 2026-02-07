import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/lobby_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// WinnerPage appears once and not again after reopen/new game
Future<void> runGameTest4(
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
  await gamePage.tapFoldButton();
  await gamePage.verifyWinnerDialogVisible();
  await gamePage.tapWinnerDialog();
  await gamePage.verifyWinnerDialogVisible(isVisible: false);

  await CommonTester.closePage(tester);
  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();

  await lobbyPage.toGame();
  await gamePage.verifyIsVisible();
  await gamePage.verifyWinnerDialogVisible(isVisible: false);

  await gamePage.startGame();
  await gamePage.verifyWinnerDialogVisible(isVisible: false);
}
