import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/model_holders.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';
import 'package:pocket_chips/domain/models/player/player_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/assets_provider.dart';

import 'mocks/purchases_repository_mock.dart';
import 'navigation_tests.mocks.dart';
import 'pages/common_tester.dart';
import 'pages/game_page.dart';
import 'pages/home_page.dart';
import 'pages/lobby_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/player_editor_page.dart';

@GenerateMocks([AppRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final repository = MockAppRepository();

  testWidgets(
    'Navigation Test 1',
    (WidgetTester tester) async {
      final mockConfig = ConfigModel(
        isDark: false,
        firstLaunch: false,
        locale: 'en',
        version: '2.0.0',
      );

      final players = List.generate(
        2,
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
            ..setScenario(MockScenario.success);

      when(repository.getConfig()).thenAnswer(
        (_) async => mockConfig,
      );
      when(repository.isProVersion()).thenAnswer(
        (_) async => true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appRepositoryProvider.overrideWithValue(repository),
            purchasesRepositoryProvider
                .overrideWithValue(mockPurchasesRepository),
            lobbyStateHolderProvider.overrideWithBuild(
              (_, __) async => mockLobbyState,
            ),
          ],
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      final homePage = HomePageTester(tester);

      // NO hiding app at HomePage
      await tester.binding.handlePopRoute();
      await homePage.verifyHomePageIsVisible();

      final onboaringPage = OnboardingPageTester(tester);

      // Closing two dialogs at HomePage
      await homePage.tapHelpButton();
      await onboaringPage.verifyAboutDialogIsVisible();
      await onboaringPage.tapSkipButton();
      await onboaringPage.tapUpdateInfoButton();
      await onboaringPage.verifyUpdateDialogIsVisible();

      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();

      await onboaringPage.verifyAboutDialogIsVisible(isVisible: false);
      await onboaringPage.verifyUpdateDialogIsVisible(isVisible: false);
      await homePage.verifyHomePageIsVisible();

      final lobbyPage = LobbyPageTester(tester);

      // Check LobbyPage UI button
      await homePage.tapContinueButton();
      await lobbyPage.verifyIsVisible();

      await CommonTester.closePage(tester);

      await homePage.verifyHomePageIsVisible();
      await lobbyPage.verifyIsVisible(isVisible: false);

      // Check LobbyPage system button
      await homePage.tapContinueButton();
      await lobbyPage.verifyIsVisible();

      await tester.binding.handlePopRoute();

      await homePage.verifyHomePageIsVisible();
      await lobbyPage.verifyIsVisible(isVisible: false);

      //Closing two dialogs at LobbyPage
      final playerEditorPage = PlayerEditorTester(tester);
      await homePage.tapContinueButton();
      await lobbyPage.verifyIsVisible();
      await lobbyPage.tapAddPlayersButton();
      await playerEditorPage.verifyIsVisible();
      await playerEditorPage.tapAvatar();
      await playerEditorPage.verifyAvatarSelectorIsVisible();

      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();

      await playerEditorPage.verifyIsVisible(isVisible: false);
      await playerEditorPage.verifyAvatarSelectorIsVisible(
        isVisible: false,
      );
      await lobbyPage.verifyIsVisible();

      //Closing dialog at GamePage
      final gamePage = GamePageTester(tester);
      await lobbyPage.toGame();
      await gamePage.verifyIsVisible();
      await gamePage.tapSettingsButton();
      await gamePage.verifySettingsIsVisible();

      await tester.binding.handlePopRoute();

      await gamePage.verifySettingsIsVisible(isVisible: false);
      await gamePage.verifyIsVisible();

      //Closing dialog by UI button
      await CommonTester.closePage(tester);

      await gamePage.verifyIsVisible(isVisible: false);
      await lobbyPage.verifyIsVisible();

      //Closing all pages by system button
      await lobbyPage.toGame();
      await gamePage.verifyIsVisible();

      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();
      await tester.binding.handlePopRoute();

      await gamePage.verifyIsVisible(isVisible: false);
      await lobbyPage.verifyIsVisible(isVisible: false);
      await homePage.verifyHomePageIsVisible();
    },
  );
}
