import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol/patrol.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import 'mocks/purchases_repository_mock.dart';
import 'navigation_test.mocks.dart';
import 'pages/common_tester.dart';
import 'pages/game_page.dart';
import 'pages/home_page.dart';
import 'pages/lobby_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/player_editor_page.dart';
import 'test_utils/test_action.dart';
import 'test_utils/test_utils.dart';

@GenerateMocks([AppRepository])
void main() {
  final repository = MockAppRepository();

  patrolTest(
    'Navigation Test 1',
    ($) async {
      final mockConfig = defaultConfig();

      final players = List.generate(
        2,
        (index) => PlayerModel(
          uid: 'test_uid_$index',
          name: 'name_$index',
          assetUrl: AssetsProvider.emptyPlayerAsset,
        ),
      );

      final mockGameState = null;
      final mockLobbyState = LobbyStateModel(
        players: players,
        banks: {for (var player in players) player.uid: 100},
      );

      final mockPurchasesRepository =
          MockPurchasesRepository(hasPurchasesForRestore: true)
            ..setScenario(MockScenario.success);

      when(repository.getConfig()).thenAnswer(
        (_) async => mockConfig,
      );
      when(repository.isProVersion()).thenAnswer(
        (_) async => true,
      );
      when(repository.getGameSessionState()).thenAnswer(
        (_) async => mockGameState,
      );

      final homePage = HomePageTester($);
      final onboaringPage = OnboardingPageTester($);
      final lobbyPage = LobbyPageTester($);
      final playerEditorPage = PlayerEditorTester($);
      final gamePage = GamePageTester($);

      await runAction(
        () => $.pumpWidgetAndSettle(
          ProviderScope(
            overrides: [
              appRepositoryProvider.overrideWithValue(repository),
              proVersionRepositoryProvider
                  .overrideWithValue(mockPurchasesRepository),
              lobbyStateHolderProvider.overrideWithBuild(
                (_, __) async => mockLobbyState,
              ),
            ],
            child: const MyApp(),
          ),
        ),
      );

      await runTestActions(
        [
          // NO hiding app at HomePage
          () => $.tester.binding.handlePopRoute(),
          homePage.verifyHomePageVisibility(),
          // Closing two dialogs at HomePage
          homePage.openOnboarding(),
          onboaringPage.verifyAboutDialogVisibility(),
          onboaringPage.skipPages(),
          onboaringPage.openUpdateInfoDialog(),
          onboaringPage.verifyUpdateDialogVisibility(),
          CommonTester.systemCloseDialog($),
          CommonTester.systemCloseDialog($),
          onboaringPage.verifyAboutDialogVisibility(isVisible: false),
          onboaringPage.verifyUpdateDialogVisibility(isVisible: false),
          homePage.verifyHomePageVisibility(),
          // Check LobbyPage UI button
          homePage.continueGame(),
          lobbyPage.verifyVisibility(),
          CommonTester.closePage($),
          homePage.verifyHomePageVisibility(),
          lobbyPage.verifyVisibility(isVisible: false),
          // Check LobbyPage system button
          homePage.continueGame(),
          lobbyPage.verifyVisibility(),
          CommonTester.systemClosePage($),
          homePage.verifyHomePageVisibility(),
          lobbyPage.verifyVisibility(isVisible: false),
          //Closing two dialogs at LobbyPage
          homePage.continueGame(),
          lobbyPage.verifyVisibility(),
          lobbyPage.addPlayer(),
          playerEditorPage.verifyVisibility(),
          playerEditorPage.openAvatarPicker(),
          playerEditorPage.verifyAvatarPickerVisibility(),
          CommonTester.systemCloseDialog($),
          CommonTester.systemCloseDialog($),
          playerEditorPage.verifyVisibility(isVisible: false),
          playerEditorPage.verifyAvatarPickerVisibility(
            isVisible: false,
          ),
          lobbyPage.verifyVisibility(),
          //Closing dialog at GamePage
          lobbyPage.toGame(),
          gamePage.verifyVisibility(),
          gamePage.openSettins(),
          gamePage.verifySettingsVisibility(),
          CommonTester.systemCloseDialog($),
          gamePage.verifySettingsVisibility(isVisible: false),
          gamePage.verifyVisibility(),
          //Closing dialog by UI button
          CommonTester.closePage($),
          gamePage.verifyVisibility(isVisible: false),
          lobbyPage.verifyVisibility(),
          //Closing all pages by system button
          lobbyPage.toGame(),
          gamePage.verifyVisibility(),
          CommonTester.systemClosePage($),
          CommonTester.systemClosePage($),
          () => $.tester.binding.handlePopRoute(),
          gamePage.verifyVisibility(isVisible: false),
          lobbyPage.verifyVisibility(isVisible: false),
          homePage.verifyHomePageVisibility(),
        ],
      )();
    },
  );
}
