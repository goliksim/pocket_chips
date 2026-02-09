import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
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
/// Сached PRO mode,  didn't restore from store - force disable
/// Checking Pro Mode during onboarding and on HomePage
Future<void> runProVersionTest2(
  PatrolTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: true,
    locale: 'en',
    version: '2.0.0',
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

  final onboardingPage = OnboardingPageTester(tester);
  final proVerionOfferPage = ProVersionOfferPageTester(tester);
  final homePage = HomePageTester(tester);

  await runAction(
    () => tester.pumpWidgetAndSettle(
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
      onboardingPage.verifyAboutDialogVisibility(),
      () => tester.pump(const Duration(seconds: 5)),
      // Verify that Pro Version is available to buy, and not applied at the HomePage
      onboardingPage.swipeOnePage(),
      () => tester.pumpAndSettle(),
      proVerionOfferPage.verifyProVersionIsAvailable(),
      onboardingPage.skipPages(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyProVersionScreen(isPro: false),
    ],
  )();
}
