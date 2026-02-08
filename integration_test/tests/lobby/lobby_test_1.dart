import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/bank_editor_dialog.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../test_utils/test_action.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Change stack via editor and settings + change blinds
Future<void> runLobbyTest1(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final bankEditor = BankEditorDialogTester(tester);
  final settingsDialog = GameSettingsDialogTester(tester);
  final gamePage = GamePageTester(tester);

  TAction verifyPlayersBank(int expectedBank) => () async {
        for (final player in players) {
          await lobbyPage.verifyPlayerBank(
              name: player.name, expectedBank: expectedBank)();
        }
      };

  await runAction(
    pumpLobbyApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(players: players),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open lobby page
      homePage.verifyHomePageIsVisible(),
      homePage.tapContinueButton(),
      lobbyPage.verifyIsVisible(),
      // Open editor and change stack, verify changes applied
      lobbyPage.tapStartingStackButton(),
      bankEditor.verifyIsVisible(),
      bankEditor.enterStack('1000'),
      bankEditor.confirm(),
      verifyPlayersBank(1000),
      // Open settings and change stack and blinds, verify changes applied
      lobbyPage.tapSettingsButton(),
      settingsDialog.verifyIsVisible(),
      settingsDialog.enterStartingStack('2000'),
      settingsDialog.enterSmallBlind('50'),
      settingsDialog.saveChanges(),
      verifyPlayersBank(2000),
      lobbyPage.toGame(),
      gamePage.verifyIsVisible(),
      gamePage.verifySmallBlind(50),
    ],
  )();
}
