import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import '../mocks/lobby_state_holder_mock.dart';
import '../mocks/purchases_repository_mock.dart';
import '../pages/game_page.dart';
import '../pages/home_page.dart';
import '../pages/lobby_page.dart';
import '../pages/player_editor_page.dart';
import '../pages/pro_version_offer_page.dart';

/// [ProVersionTest]
/// No cached PRO mode, store is unavailable
/// Checking all pro features locked
Future<void> runProVersionTest7(
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
    noProPlayerCount - 1,
    (index) => PlayerModel(
      uid: 'test_uid_$index',
      name: 'name_$index',
      assetUrl: AssetsProvider.emptyPlayerAsset,
    ),
  );

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
    (_) async => false,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        proVersionRepository.overrideWithValue(mockPurchasesRepository),
        lobbyStateHolderProvider.overrideWith(
          () => MockLobbyStateHolder(initialState: mockLobbyState),
        )
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final homePage = HomePageTester(tester);

  await homePage.verifyIsNotProVersionScreen();

  final proVersionPage = ProVersionOfferPageTester(tester);

  // Change theme feature
  await homePage.tapChangeThemeButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  // Continue game feature
  await homePage.tapContinueButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  // Solver feature
  await homePage.tapSolverButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  final lobbyPage = LobbyPageTester(tester);

  await homePage.tapNewGameButton();
  await homePage.verifyConfirmationWindowIsVisible();
  await homePage.tapConfirmationButton();
  await lobbyPage.verifyIsVisible();

  // Saved players feature
  await lobbyPage.tapSavedPlayersButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  final playerEditorPage = PlayerEditorTester(tester);

  // Add players feature (5th player free, 6th player unavailable)
  await lobbyPage.tapAddPlayersButton();
  final testName = 'test_123';
  await playerEditorPage.verifyIsVisible();
  await playerEditorPage.enterName(testName);
  await playerEditorPage.tapAvatar();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();
  await playerEditorPage.tapConfirmButton();
  await playerEditorPage.verifyIsVisible(isVisible: false);
  await tester.pumpAndSettle(Duration(seconds: 1)); // Auto-scroll waiting
  await lobbyPage.findPlayerWithName(testName);

  await lobbyPage.tapAddPlayersButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  // Save player feature
  await lobbyPage.savePlayerByName(testName);
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();

  final gamePage = GamePageTester(tester);

  // Undo action feature
  await lobbyPage.toGame();
  await gamePage.verifyIsVisible();
  await gamePage.verifyGameStatus(GameStatusEnum.notStarted);
  await gamePage.startGame();
  await gamePage.verifyGameStatus(GameStatusEnum.preFlop);
  await gamePage.tapUndoActionButton();
  await proVersionPage.verifyOfferIsVisible();
  await proVersionPage.tapCloseButton();
}
