import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';

import '../../game_test.mocks.dart';
import '../../pages/game_page.dart';
import '../../pages/game_settings_dialog.dart';
import '../../pages/lobby_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Change stack and blinds via settings on GamePage
Future<void> runGameTest1(
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

  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible(isVisible: false);

  final gamePage = GamePageTester(tester);
  await gamePage.verifyIsVisible();

  await gamePage.tapSettingsButton();
  final settingsDialog = GameSettingsDialogTester(tester);
  await settingsDialog.verifyIsVisible();
  await settingsDialog.enterStartingStack('2000');
  await settingsDialog.enterSmallBlind('50');
  await settingsDialog.saveChanges();

  for (final player in players) {
    await gamePage.verifyPlayerBank(
      name: player.name,
      expectedBank: 2000,
    );
  }

  await gamePage.verifySmallBlind(50);
}
