import 'package:patrol_finders/patrol_finders.dart';
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
  PatrolTester tester,
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
          await lobbyPage.verifyPlayerBankValue(
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
      homePage.verifyHomePageVisibility(),
      homePage.continueGame(),
      lobbyPage.verifyVisibility(),
      // Open editor and change stack, verify changes applied
      lobbyPage.openInitialStackEditor(),
      bankEditor.verifyVisibility(),
      bankEditor.enterInitialStack('1000'),
      bankEditor.confirmAndExit(),
      verifyPlayersBank(1000),
      // Open settings and change stack and blinds, verify changes applied
      lobbyPage.openSettings(),
      settingsDialog.verifyVisibility(),
      settingsDialog.enterStartingStack('2000'),
      settingsDialog.enterSmallBlind('50'),
      settingsDialog.saveChangesAndExit(),
      verifyPlayersBank(2000),
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.verifySmallBlindValues(50),
    ],
  )();
}
