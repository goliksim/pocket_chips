import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../lobby_tests.mocks.dart';
import '../../pages/bank_editor_dialog.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Change stack via editor and settings + change blinds
Future<void> runLobbyTest1(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final savedPlayers = <PlayerModel>[];

  await pumpLobbyApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(players: players),
    savedPlayers: savedPlayers,
  );

  final homePage = HomePageTester(tester);
  await homePage.verifyHomePageIsVisible();
  await homePage.tapContinueButton();

  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();

  // Change starting stack via bank editor
  await lobbyPage.tapStartingStackButton();
  final bankEditor = BankEditorDialogTester(tester);
  await bankEditor.verifyIsVisible();
  await bankEditor.enterStack('1000');
  await bankEditor.confirm();

  for (final player in players) {
    await lobbyPage.verifyPlayerBank(
      name: player.name,
      expectedBank: 1000,
    );
  }

  // Change stack and blinds via settings
  await lobbyPage.tapSettingsButton();
  final settingsDialog = GameSettingsDialogTester(tester);
  await settingsDialog.verifyIsVisible();
  await settingsDialog.enterStartingStack('2000');
  await settingsDialog.enterSmallBlind('50');
  await settingsDialog.saveChanges();

  for (final player in players) {
    await lobbyPage.verifyPlayerBank(
      name: player.name,
      expectedBank: 2000,
    );
  }

  // Check blinds on game page
  await lobbyPage.toGame();
  final gamePage = GamePageTester(tester);
  await gamePage.verifyIsVisible();

  await gamePage.verifySmallBlind(50);
}
