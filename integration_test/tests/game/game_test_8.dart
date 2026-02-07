import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Undo action returns to previous state
Future<void> runGameTest8(
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
  await gamePage.verifyUndoButtonIsVisible();
  await gamePage.tapUndoActionButton();

  await gamePage.verifyGameStatus(GameStatusEnum.notStarted);
  await gamePage.verifyUndoButtonIsNotVisible();
}
