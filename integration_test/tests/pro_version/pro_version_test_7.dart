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
    () => tester.pumpWidgetAndSettle(
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
      homePage.verifyProVersionScreen(isPro: false),
      // Check theme change pro feature
      homePage.changeTheme(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      // Check continue game pro feature
      homePage.continueGame(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      // Check solver pro feature
      homePage.openSolver(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      //
      homePage.newGame(),
      homePage.verifyConfirmationWindowVisibility(),
      homePage.confirmConfirmationDialog(),
      lobbyPage.verifyVisibility(),
      // Check saved players pro feature
      lobbyPage.openSavedPlayersDialog(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      lobbyPage.savePlayerByName(players.first.name),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      // Check custom icons pro feature
      lobbyPage.addPlayer(),
      playerEditorPage.verifyVisibility(),
      playerEditorPage.enterName(testName),
      playerEditorPage.openAvatarPicker(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      playerEditorPage.confirmEditingAndExit(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      playerEditorPage.verifyVisibility(isVisible: false),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      lobbyPage.findPlayerWithName(testName),
      // Check more players pro feature
      lobbyPage.addPlayer(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
      // Check undo action pro feature
      lobbyPage.toGame(),
      gamePage.verifyVisibility(),
      gamePage.verifyGameStatus(GameStatusEnum.notStarted),
      gamePage.startGame(),
      gamePage.verifyGameStatus(GameStatusEnum.preFlop),
      gamePage.undoLastAction(),
      proVersionPage.verifyOfferVisibility(),
      proVersionPage.closeOfferDialog(),
    ],
  )();
}
