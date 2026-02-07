import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../../game_test.mocks.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/player_editor_page.dart';
import '../../pages/saved_players_page.dart';
import 'game_test_utils.dart';

/// [GameTest]
/// Add new player and saved player from table + max players checks
Future<void> runGameTest2(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final players = buildPlayers(8);
  final savedPlayers = buildPlayers(2, namePrefix: 'saved');

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
  await gamePage.verifyIsVisible();

  // Add new player
  await gamePage.tapAddNewPlayerButton();

  final playerEditor = PlayerEditorTester(tester);
  await playerEditor.verifyIsVisible();
  await playerEditor.enterName('new_1');
  await playerEditor.enterBank('5000');
  await playerEditor.tapConfirmButton();

  await tester.pumpAndSettle();
  expect(find.byKey(GameTableKeys.playerCard('new_1')), findsOneWidget);

  // Add saved player
  await gamePage.tapAddSavedPlayerButton();

  final savedPage = SavedPlayersPageTester(tester);
  await savedPage.verifyIsVisible();
  await savedPage.usePlayerByName(savedPlayers.first.name);
  await savedPage.usePlayerByName(savedPlayers.last.name);
  await CommonTester.closeDialog(tester);
  await tester.pumpAndSettle();

  expect(
    find.byKey(GameTableKeys.playerCard(savedPlayers.first.name)),
    findsOneWidget,
  );
  expect(
    find.byKey(GameTableKeys.playerCard(savedPlayers.last.name)),
    findsNothing,
  );

  await gamePage.verifyAddMainButtonVisible(false);
}
