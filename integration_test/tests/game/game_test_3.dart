import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/utils/extensions.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Raise flow: chips, slider, min/max, selected value, next player
Future<void> runGameTest3(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final gamePage = GamePageTester(tester);
  final minTotal = 100.toCompact;
  final maxTotal = 5000.toCompact;

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
      //Open game page and start game
      openGamePage(tester),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.verifyCurrentPlayer(players.first.name),
      // Open raise dialog and verify min/max values
      gamePage.raise(),
      gamePage.verifyRaiseFieldVisibility(),
      gamePage.verifyRaiseMinMaxValues(
        minValue: minTotal,
        maxValue: maxTotal,
      ),
      () async {
        final initialValue = await gamePage.getRaiseSliderValue();
        expect(initialValue, 75);
      },
      // Select 10 chips and verify slider value updated
      gamePage.tapRaiseChip(10),
      () async {
        final chipValue = await gamePage.getRaiseSliderValue();
        expect(chipValue, 85);
      },
      // Drag slider to max and verify value
      gamePage.dragRaiseSliderToMax(),
      gamePage.confirmRaise(),
      gamePage.verifyPlayerBetValue(
        name: players.first.name,
        expectedBet: 5000,
      ),
      gamePage.verifyCurrentPlayer(players.first.name, isVisible: false),
      gamePage.verifyCurrentPlayer(players.last.name),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
    ],
  )();
}
