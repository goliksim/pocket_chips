import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Change stack and blinds via settings on GamePage
Future<void> runGameTest1(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final lobbyPage = LobbyPageTester(tester);
  final gamePage = GamePageTester(tester);
  final settingsDialog = GameSettingsDialogTester(tester);

  TAction verifyPlayersBank() => runTestActions(
        players.map(
          (player) => gamePage.verifyPlayerBank(
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
      lobbyPage.verifyIsVisible(isVisible: false),
      gamePage.verifyIsVisible(),
      // Open settings and change stack and blinds
      gamePage.tapSettingsButton(),
      settingsDialog.verifyIsVisible(),
      settingsDialog.enterStartingStack('2000'),
      settingsDialog.enterSmallBlind('50'),
      settingsDialog.saveChanges(),
      // Verify changes applied
      verifyPlayersBank(),
      gamePage.verifySmallBlind(50),
    ],
  )();
}
