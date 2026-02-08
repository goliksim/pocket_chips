import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/purchases_repository_mock.dart';
import '../../pages/home_page.dart';
import '../../pages/onboarding_page.dart';
import '../../pages/pro_version_offer_page.dart';
import '../../test_utils/test_action.dart';

/// [ProVersionTest]
/// Cached PRO mode, store is available and returned PRO MODE
/// Restored from store
Future<void> runProVersionTest1(
  WidgetTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: true,
    locale: 'en',
    version: '2.0.0',
  );

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );

  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.success);

  final onboardingPage = OnboardingPageTester(tester);
  final proVerionOfferPage = ProVersionOfferPageTester(tester);
  final homePage = HomePageTester(tester);

  await runAction(
    () => tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(repository),
          proVersionRepositoryProvider.overrideWithValue(
            mockPurchasesRepository,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Wait for onboarding to load
      () => tester.pumpAndSettle(),
      onboardingPage.verifyAboutDialogIsVisible(),
      // Verify PRO version is purchased and applyed on the HomePage
      onboardingPage.swipePage(),
      () => tester.pumpAndSettle(const Duration(seconds: 3)),
      proVerionOfferPage.verifyProVersionIsPurchased(),
      onboardingPage.tapSkipButton(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyIsProVersionScreen(),
    ],
  )();
}
