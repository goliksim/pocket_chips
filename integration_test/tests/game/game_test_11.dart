import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Verify custom bets setting changes raise behavior
Future<void> runGameTest11(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final lobbyPage = LobbyPageTester(tester);
  final gamePage = GamePageTester(tester);
  final settingsDialog = GameSettingsDialogTester(tester);

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
      CommonTester.closePage(tester),
      lobbyPage.verifyVisibility(),
      lobbyPage.openSettings(),
      settingsDialog.verifyVisibility(),
      settingsDialog.verifyAllowCustomBetsValue(false),
      settingsDialog.saveChangesAndExit(),
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.startGame(),
      gamePage.verifyCurrentPlayer(players.first.name),
      gamePage.raise(),
      gamePage.verifyRaiseFieldVisibility(),
      gamePage.verifyRaiseSliderValue(75),
      gamePage.verifyRaiseMinMaxValues(
        minValue: '100',
        maxValue: '5K',
      ),
      gamePage.verifyRaiseConfirmButtonAlertState(hasAlert: false),
      gamePage.dragRaiseSliderToMin(),
      gamePage.verifyRaiseSliderValue(75),
      gamePage.confirmRaise(),
      gamePage.verifyPlayerBetValue(
        name: players.first.name,
        expectedBet: 100,
      ),
      gamePage.verifyPlayerBankValue(
        name: players.first.name,
        expectedBank: 4900,
      ),
      CommonTester.closePage(tester),
      lobbyPage.verifyVisibility(),
      () => tester(LobbyKeys.resetLobbyButton).tap(),
      () => tester.pumpAndSettle(),
      () => tester(CommonKeys.confirmButton).tap(),
      () => tester.pumpAndSettle(),
      lobbyPage.openSettings(),
      settingsDialog.verifyVisibility(),
      settingsDialog.verifyAllowCustomBetsValue(false),
      settingsDialog.toggleAllowCustomBets(),
      settingsDialog.verifyAllowCustomBetsValue(true),
      settingsDialog.saveChangesAndExit(),
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.startGame(),
      gamePage.verifyCurrentPlayer(players.first.name),
      gamePage.raise(),
      gamePage.verifyRaiseFieldVisibility(),
      gamePage.verifyRaiseSliderValue(75),
      gamePage.verifyRaiseConfirmButtonAlertState(hasAlert: false),
      gamePage.dragRaiseSliderToMin(),
      gamePage.verifyRaiseSliderValue(25),
      gamePage.verifyRaiseConfirmButtonAlertState(hasAlert: true),
      gamePage.confirmRaise(),
      gamePage.verifyPlayerBetValue(
        name: players.first.name,
        expectedBet: 50,
      ),
      gamePage.verifyPlayerBankValue(
        name: players.first.name,
        expectedBank: 4950,
      ),
    ],
  )();
}
