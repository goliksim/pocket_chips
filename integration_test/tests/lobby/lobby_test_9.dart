import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../../lobby_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import 'lobby_test_utils.dart';

/// [LobbyTest]
/// Edit player (avatar, name, bank, dealer)
Future<void> runLobbyTest9(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(2);
  final dealerId = players[1].uid;
  final savedPlayers = <PlayerModel>[];

  await pumpLobbyApp(
    tester: tester,
    repository: repository,
    lobbyState: buildLobbyState(
      players: players,
      dealerId: dealerId,
    ),
    savedPlayers: savedPlayers,
  );

  final homePage = HomePageTester(tester);
  await homePage.tapContinueButton();

  final lobbyPage = LobbyPageTester(tester);
  await lobbyPage.verifyIsVisible();

  await tester.tap(find.byKey(LobbyKeys.playerCard(players.first.name)));

  final playerEditor = PlayerEditorTester(tester);
  await playerEditor.verifyIsVisible();
  const newName = 'edit_name';
  const newBank = '1500';
  const avatarIndex = 1;
  final newAssetUrl = AssetsProvider.playerAssetByIndex(avatarIndex);

  await playerEditor.enterName(newName);
  await playerEditor.enterBank(newBank);
  await playerEditor.tapAvatar();
  await playerEditor.verifyAvatarSelectorIsVisible();
  await playerEditor.selectAvatar(avatarIndex);
  await playerEditor.verifyAvatarByAssetUrl(newAssetUrl);
  await playerEditor.toggleDealer();
  await playerEditor.tapConfirmButton();

  await tester.pumpAndSettle(Duration(seconds: 2));
  await lobbyPage.findPlayerWithName(newName);
  await lobbyPage.verifyPlayerBank(name: newName, expectedBank: 1500);
  await lobbyPage.findPlayerWithAssetUrl(newAssetUrl);
  await lobbyPage.verifyDealerVisible(name: newName, isVisible: true);
  await lobbyPage.verifyDealerVisible(
    name: players[1].name,
    isVisible: false,
  );

  expect(find.text(players.first.name), findsNothing);
}
