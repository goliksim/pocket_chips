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
import 'navigation_test.mocks.dart';
import 'pages/common_tester.dart';
import 'pages/game_page.dart';
import 'pages/home_page.dart';
import 'pages/lobby_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/player_editor_page.dart';
import 'test_utils/test_action.dart';

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
          MockPurchasesRepository(hasPurchasesForRestore: true)
            ..setScenario(MockScenario.success);

      when(repository.getConfig()).thenAnswer(
        (_) async => mockConfig,
      );
      when(repository.isProVersion()).thenAnswer(
        (_) async => true,
      );

      final homePage = HomePageTester(tester);
      final onboaringPage = OnboardingPageTester(tester);
      final lobbyPage = LobbyPageTester(tester);
      final playerEditorPage = PlayerEditorTester(tester);
      final gamePage = GamePageTester(tester);

      await runAction(
        () => tester.pumpWidget(
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

      // Run test actions
      await runTestActions(
        [
          // NO hiding app at HomePage
          () => tester.pumpAndSettle(),
          () => tester.binding.handlePopRoute(),
          homePage.verifyHomePageIsVisible(),
          // Closing two dialogs at HomePage
          homePage.tapHelpButton(),
          onboaringPage.verifyAboutDialogIsVisible(),
          onboaringPage.tapSkipButton(),
          onboaringPage.tapUpdateInfoButton(),
          onboaringPage.verifyUpdateDialogIsVisible(),
          CommonTester.systemCloseDialog(tester),
          CommonTester.systemCloseDialog(tester),
          onboaringPage.verifyAboutDialogIsVisible(isVisible: false),
          onboaringPage.verifyUpdateDialogIsVisible(isVisible: false),
          homePage.verifyHomePageIsVisible(),
          // Check LobbyPage UI button
          homePage.tapContinueButton(),
          lobbyPage.verifyIsVisible(),
          CommonTester.closePage(tester),
          homePage.verifyHomePageIsVisible(),
          lobbyPage.verifyIsVisible(isVisible: false),
          // Check LobbyPage system button
          homePage.tapContinueButton(),
          lobbyPage.verifyIsVisible(),
          CommonTester.systemClosePage(tester),
          homePage.verifyHomePageIsVisible(),
          lobbyPage.verifyIsVisible(isVisible: false),
          //Closing two dialogs at LobbyPage
          homePage.tapContinueButton(),
          lobbyPage.verifyIsVisible(),
          lobbyPage.tapAddPlayersButton(),
          playerEditorPage.verifyIsVisible(),
          playerEditorPage.tapAvatar(),
          playerEditorPage.verifyAvatarSelectorIsVisible(),
          CommonTester.systemCloseDialog(tester),
          CommonTester.systemCloseDialog(tester),
          playerEditorPage.verifyIsVisible(isVisible: false),
          playerEditorPage.verifyAvatarSelectorIsVisible(
            isVisible: false,
          ),
          lobbyPage.verifyIsVisible(),
          //Closing dialog at GamePage
          lobbyPage.toGame(),
          gamePage.verifyIsVisible(),
          gamePage.tapSettingsButton(),
          gamePage.verifySettingsIsVisible(),
          CommonTester.systemCloseDialog(tester),
          gamePage.verifySettingsIsVisible(isVisible: false),
          gamePage.verifyIsVisible(),
          //Closing dialog by UI button
          CommonTester.closePage(tester),
          gamePage.verifyIsVisible(isVisible: false),
          lobbyPage.verifyIsVisible(),
          //Closing all pages by system button
          lobbyPage.toGame(),
          gamePage.verifyIsVisible(),
          CommonTester.systemClosePage(tester),
          CommonTester.systemClosePage(tester),
          () => tester.binding.handlePopRoute(),
          gamePage.verifyIsVisible(isVisible: false),
          lobbyPage.verifyIsVisible(isVisible: false),
          homePage.verifyHomePageIsVisible(),
        ],
      )();
    },
  );
}
