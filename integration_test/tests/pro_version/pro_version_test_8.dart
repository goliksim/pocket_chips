import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';
import 'package:pocket_chips/utils/theme/themes.dart';

import '../../mocks/lobby_state_holder_mock.dart';
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/common_tester.dart';
import '../../pages/game_page.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import '../../pages/pro_version_offer_page.dart';
import '../../pages/saved_players_page.dart';
import '../../pages/solver_page.dart';
import '../../test_utils/test_action.dart';

/// [ProVersionTest]
/// Cached PRO mode, store is unavailable
/// Checking all pro features available
Future<void> runProVersionTest8(
  PatrolTester tester,
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

  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: false)
        ..setScenario(MockScenario.offline);

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );
  when(repository.getSavedPlayers()).thenAnswer(
    (_) async => savedPlayers,
  );

  final homePage = HomePageTester(tester);
  final proVersionPage = ProVersionOfferPageTester(tester);
  final solverPage = SolverPageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final savedPlayersPage = SavedPlayersPageTester(tester);
  final playerEditorPage = PlayerEditorTester(tester);
  final testName = 'test_123';
  final assetIndex = 0;
  final assetUrl = AssetsProvider.playerAssetByIndex(0);
  final gamePage = GamePageTester(tester);

  await runAction(
    () => tester.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(repository),
          proVersionRepositoryProvider.overrideWithValue(
            mockPurchasesRepository,
          ),
          lobbyStateHolderProvider.overrideWith(
            () => MockLobbyStateHolder(initialState: mockLobbyState),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Check pro version on HomePage
      homePage.verifyProVersionScreen(),
      // Check theme change pro feature
      homePage.changeTheme(),
      homePage.verifyTheme(Themes.dark()),
      // Check solver pro feature
      homePage.openSolver(),
      solverPage.verifyVisibility(),
      CommonTester.closeDialog(tester),
      // Check continue game pro feature
      homePage.continueGame(),
      lobbyPage.verifyVisibility(),
      // Check saved players pro feature
      lobbyPage.openSavedPlayersDialog(),
      savedPlayersPage.verifyVisibility(),
      savedPlayersPage.usePlayerByName(restoredName),
      CommonTester.closeDialog(tester),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(restoredName),
      // Check more players pro feature
      // Check custom icons pro feature
      lobbyPage.addPlayer(),
      playerEditorPage.verifyVisibility(),
      playerEditorPage.enterName(testName),
      playerEditorPage.openAvatarPicker(),
      playerEditorPage.verifyAvatarPickerVisibility(),
      playerEditorPage.selectAvatarByIndex(assetIndex),
      playerEditorPage.verifyAvatarByAssetUrl(assetUrl),
      playerEditorPage.confirmEditingAndExit(),
      playerEditorPage.verifyVisibility(isVisible: false),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(testName),
      lobbyPage.findPlayerWithAssetUrl(assetUrl),
      // Check saving player pro feature
      lobbyPage.savePlayerByName(testName),
      proVersionPage.verifyOfferVisibility(isVisible: false),
      // Check undo action pro feature
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.undoLastAction(),
      gamePage.verifyUndoButtonVisibility(isVisible: false),
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
    ],
  )();
}
