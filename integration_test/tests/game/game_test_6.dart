import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_tests.mocks.dart';
import '../../pages/game_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// WinnerChoiceWindow appears immediately on GamePage at showdown
Future<void> runGameTest6(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];
  final bets = {
    players.first.uid: 10,
    players.last.uid: 20,
  };

  await pumpGameApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(
      players: players,
      dealerId: players.first.uid,
      gameState: GameStatusEnum.showdown,
    ),
    savedPlayers: savedPlayers,
    sessionState: buildSessionState(bets: bets),
  );

  await openGamePage(tester);
  final gamePage = GamePageTester(tester);

  await gamePage.verifyIsVisible();
  await gamePage.verifyWinnerChoiceDialogVisible();
}
