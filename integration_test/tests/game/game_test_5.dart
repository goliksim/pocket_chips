import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_tests.mocks.dart';
import '../../pages/game_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// WinnerChoiceWindow does not close by system back button
Future<void> runGameTest5(
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
      bank: 200,
    ),
    savedPlayers: savedPlayers,
  );

  await openGamePage(tester);
  final gamePage = GamePageTester(tester);

  await gamePage.startGame();
  await gamePage.tapRaiseButton();

  await tester.pump(Duration(seconds: 1));
  await gamePage.dragRaiseSliderToMax();
  await gamePage.tapRaiseConfirm();

  await gamePage.tapAllInButton();
  await gamePage.verifyWinnerChoiceDialogVisible();

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

  await gamePage.verifyWinnerChoiceDialogVisible();
}
