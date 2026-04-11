import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Edit player (avatar, name, bank, dealer)
Future<void> runLobbyTest9(
  PatrolTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final dealerId = players[1].uid;
  final savedPlayers = <PlayerModel>[];

  final homePage = HomePageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final playerEditor = PlayerEditorTester(tester);
  const newName = 'edit_name';
  const newBank = '1500';
  const avatarIndex = 1;
  final newAssetUrl = AssetsProvider.playerAssetByIndex(avatarIndex);

  await runAction(
    pumpLobbyApp(
      tester: tester,
      repository: repository,
      lobbyState: buildLobbyState(
        players: players,
        dealerId: dealerId,
      ),
      savedPlayers: savedPlayers,
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open lobby page
      homePage.continueGame(),
      lobbyPage.verifyVisibility(),
      // Edit player, verify it's edited
      () => tester(LobbyKeys.playerCard(players.first.name)).tap(),
      playerEditor.verifyVisibility(),
      playerEditor.enterName(newName),
      playerEditor.enterBank(newBank),
      playerEditor.openAvatarPicker(),
      playerEditor.verifyAvatarPickerVisibility(),
      playerEditor.selectAvatarByIndex(avatarIndex),
      playerEditor.verifyAvatarByAssetUrl(newAssetUrl),
      playerEditor.toggleDealer(),
      playerEditor.confirmEditingAndExit(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 2)),
      lobbyPage.findPlayerWithName(newName),
      lobbyPage.verifyPlayerBankValue(name: newName, expectedBank: 1500),
      lobbyPage.findPlayerWithAssetUrl(newAssetUrl),
      lobbyPage.verifyDealerVisibility(name: newName, isVisible: true),
      lobbyPage.verifyDealerVisibility(name: players[1].name, isVisible: false),
      () async => expect(find.text(players.first.name), findsNothing),
    ],
  )();
}
