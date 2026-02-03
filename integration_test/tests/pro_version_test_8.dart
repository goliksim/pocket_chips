import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';
import 'package:pocket_chips/utils/theme/themes.dart';

import '../mocks/lobby_state_holder_mock.dart';
import '../mocks/pro_version_manager_mock.dart';
import '../pages/common_tester.dart';
import '../pages/game_page.dart';
import '../pages/home_page.dart';
import '../pages/lobby_page.dart';
import '../pages/player_editor_page.dart';
import '../pages/pro_version_offer_page.dart';
import '../pages/saved_players_page.dart';
import '../pages/solver_page.dart';

/// [ProVersionTest]
/// Cached PRO mode, store is unavailable
/// Checking all pro features available
Future<void> runProVersionTest8(
  WidgetTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: false,
    locale: 'en',
    version: '2.0.0',
  );
  final players = List.generate(
    noProPlayerCount,
    (index) => PlayerModel(
      uid: 'test_uid_$index',
      name: 'name_$index',
      assetUrl: AssetsProvider.emptyPlayerAsset,
    ),
  );

  final restoredName = 'saved_name';
  final savedPlayers = [
    PlayerModel(
      uid: 'saved-uid',
      name: restoredName,
      assetUrl: AssetsProvider.emptyPlayerAsset,
    ),
  ];

  final mockLobbyState = LobbyStateModel(
    players: players,
    banks: {for (var player in players) player.uid: 100},
  );

  // Создаем мок-менеджер с начальным состоянием и состоянием после restorePurchases
  final mockManager = MockProVersionManager(
    restoredState: null,
  );

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );
  when(repository.getSavedPlayers()).thenAnswer(
    (_) async => savedPlayers,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        proVersionManagerProvider.overrideWith(() => mockManager),
        lobbyStateHolderProvider.overrideWith(
          () => MockLobbyStateHolder(initialState: mockLobbyState),
        ),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final homePage = HomePageTester(tester);

  await homePage.verifyIsProVersionScreen();

  final proVersionPage = ProVersionOfferPageTester(tester);

  // Change theme feature
  await homePage.tapChangeThemeButton();
  await homePage.verifyTheme(Themes.dark());

  final solverPage = SolverPageTester(tester);

  // Solver feature
  await homePage.tapSolverButton();
  await solverPage.verifyIsVisible();
  await CommonTester.closeDialog(tester);

  final lobbyPage = LobbyPageTester(tester);

  // Continue game feature
  await homePage.tapContinueButton();
  await lobbyPage.verifyIsVisible();

  final savedPlayersPage = SavedPlayersPageTester(tester);

  // Saved players feature
  await lobbyPage.tapSavedPlayersButton();
  await savedPlayersPage.verifyIsVisible();
  await savedPlayersPage.usePlayerByName(restoredName);
  await CommonTester.closeDialog(tester);
  await tester.pumpAndSettle(Duration(seconds: 1)); // Auto-scroll waiting
  await lobbyPage.findPlayerWithName(restoredName);

  final playerEditorPage = PlayerEditorTester(tester);

  // Add players feature (6th player available)
  await lobbyPage.tapAddPlayersButton();
  final testName = 'test_123';
  final assetIndex = 0;
  final assetUrl = AssetsProvider.playerAssetByIndex(0);
  await playerEditorPage.verifyIsVisible();
  await playerEditorPage.enterName(testName);
  await playerEditorPage.tapAvatar();
  await playerEditorPage.verifyAvatarSelectorIsVisible();
  await playerEditorPage.selectAvatar(assetIndex);
  await playerEditorPage.verifyAvatarByAssetUrl(assetUrl);
  await playerEditorPage.tapConfirmButton();
  await playerEditorPage.verifyIsVisible(isVisible: false);
  await tester.pumpAndSettle(Duration(seconds: 1)); // Auto-scroll waiting
  await lobbyPage.findPlayerWithName(testName);
  await lobbyPage.findPlayerWithAssetUrl(assetUrl);

  // Save player feature
  await lobbyPage.savePlayerByName(testName);
  await proVersionPage.verifyOfferIsVisible(isVisible: false);

  final gamePage = GamePageTester(tester);

  // Undo action feature
  await lobbyPage.toGame();
  await gamePage.verifyIsVisible();
  await gamePage.verifyGameStatus(GameStatusEnum.notStarted);
  await gamePage.startGame();
  await gamePage.verifyGameStatus(GameStatusEnum.preFlop);
  await gamePage.tapUndoActionButton();
  await gamePage.verifyUndoButtonIsNotVisible();
  await gamePage.verifyGameStatus(GameStatusEnum.notStarted);
}
