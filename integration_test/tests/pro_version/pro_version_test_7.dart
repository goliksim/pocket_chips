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

import '../../mocks/lobby_state_holder_mock.dart';
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/game_page.dart';
import '../../pages/home_page.dart';
import '../../pages/lobby_page.dart';
import '../../pages/player_editor_page.dart';
import '../../pages/pro_version_offer_page.dart';
import '../../test_utils/test_action.dart';

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
  final testName = 'test_123';

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

  final homePage = HomePageTester(tester);
  final proVersionPage = ProVersionOfferPageTester(tester);
  final lobbyPage = LobbyPageTester(tester);
  final playerEditorPage = PlayerEditorTester(tester);
  final gamePage = GamePageTester(tester);

  await runAction(
    () => tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(repository),
          proVersionRepositoryProvider.overrideWithValue(
            mockPurchasesRepository,
          ),
          lobbyStateHolderProvider.overrideWith(
            () => MockLobbyStateHolder(
              initialState: mockLobbyState,
              keepStateOnNewGame: true,
            ),
          )
        ],
        child: const MyApp(),
      ),
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Check no pro version on HomePage
      () => tester.pumpAndSettle(),
      homePage.verifyIsNotProVersionScreen(),
      // Check theme change pro feature
      homePage.tapChangeThemeButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      // Check continue game pro feature
      homePage.tapContinueButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      // Check solver pro feature
      homePage.tapSolverButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      //
      homePage.tapNewGameButton(),
      homePage.verifyConfirmationWindowIsVisible(),
      homePage.tapConfirmationButton(),
      lobbyPage.verifyIsVisible(),
      // Check saved players pro feature
      lobbyPage.tapSavedPlayersButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      lobbyPage.savePlayerByName(players.first.name),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      // Check custom icons pro feature
      lobbyPage.tapAddPlayersButton(),
      playerEditorPage.verifyIsVisible(),
      playerEditorPage.enterName(testName),
      playerEditorPage.tapAvatar(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      playerEditorPage.tapConfirmButton(),
      () => tester.pumpAndSettle(const Duration(seconds: 1)),
      playerEditorPage.verifyIsVisible(isVisible: false),
      () => tester.pumpAndSettle(const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(testName),
      // Check more players pro feature
      lobbyPage.tapAddPlayersButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
      // Check undo action pro feature
      lobbyPage.toGame(),
      gamePage.verifyIsVisible(),
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.tapUndoActionButton(),
      proVersionPage.verifyOfferIsVisible(),
      proVersionPage.tapCloseButton(),
    ],
  )();
}
