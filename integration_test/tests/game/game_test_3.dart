import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/utils/extensions.dart';

import '../../game_tests.mocks.dart';
import '../../pages/game_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Raise flow: chips, slider, min/max, selected value, next player
Future<void> runGameTest3(
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
  await gamePage.verifyGameStatus(GameStatusEnum.preFlop);
  await gamePage.verifyCurrentPlayer(players.first.name);

  await gamePage.tapRaiseButton();
  await gamePage.verifyRaiseFieldVisible();

  final minTotal = 100.toCompact;
  final maxTotal = 5000.toCompact;
  await gamePage.verifyRaiseMinMax(
    minValue: minTotal,
    maxValue: maxTotal,
  );

  final initialValue = await gamePage.getRaiseSliderValue();
  expect(initialValue, 75);

  await gamePage.tapRaiseChip(10);
  final chipValue = await gamePage.getRaiseSliderValue();
  expect(chipValue, 85);

  await gamePage.dragRaiseSliderToMax();
  final selectedValue = await gamePage.getRaiseSliderValue();

  await gamePage.tapRaiseConfirm();

  final expectedBet = 25 + selectedValue;
  await gamePage.verifyPlayerBet(
    name: players.first.name,
    expectedBet: expectedBet,
  );
  await gamePage.verifyCurrentPlayer(players.first.name, isVisible: false);
  await gamePage.verifyCurrentPlayer(players.last.name);
  await gamePage.verifyGameStatus(GameStatusEnum.preFlop);
}
