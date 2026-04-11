import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Change stack and blinds via settings on GamePage
Future<void> runGameTest1(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final lobbyPage = LobbyPageTester(tester);
  final gamePage = GamePageTester(tester);
  final settingsDialog = GameSettingsDialogTester(tester);

  TAction verifyPlayersBank() => runTestActions(
        players.map(
          (player) => gamePage.verifyPlayerBankValue(
            name: player.name,
            expectedBank: 2000,
          ),
        ),
      );

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

  // Run test actions
  await runTestActions(
    [
      // Open game page
      openGamePage(tester),
      lobbyPage.verifyVisibility(isVisible: false),
      gamePage.verifyVisibility(),
      // Open settings and change stack and blinds
      gamePage.openSettins(),
      settingsDialog.verifyVisibility(),
      settingsDialog.enterStartingStack('2000'),
      settingsDialog.enterSmallBlind('50'),
      settingsDialog.saveChangesAndExit(),
      // Verify changes applied
      verifyPlayersBank(),
      gamePage.verifySmallBlindValues(50),
    ],
  )();
}
