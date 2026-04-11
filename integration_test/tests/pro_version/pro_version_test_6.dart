import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/purchases_repository_mock.dart';
import '../../pages/home_page.dart';
import '../../pages/onboarding_page.dart';
import '../../pages/pro_version_offer_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';

/// [ProVersionTest]
/// No cached PRO mode, store is unavailable
/// Closing onboarding, returning with connection, restore PRO MODE
/// Checking Pro Mode during onboarding and on HomePage
Future<void> runProVersionTest6(
  PatrolTester tester,
  AppRepository repository,
) async {
  final mockConfig = (await defaultConfig()).copyWith(
    firstLaunch: true,
  );
  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.offline);

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => false,
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
      // Verify onboarding is shown
      onboardingPage.verifyAboutDialogVisibility(),
      // Verify PRO MODE is not available, store is offline, check PRO is not applied at the HomePage
      onboardingPage.swipeOnePage(),
      () => tester.pumpAndSettle(),
      proVerionOfferPage.verifyProVersionIsNotAvailable(),
      onboardingPage.skipPages(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyProVersionScreen(isPro: false),
      // Connecting to internet
      () async => mockPurchasesRepository.setScenario(MockScenario.success),
      // Returning to onboarding, verifying that PRO MODE is available to buy
      homePage.openOnboarding(),
      onboardingPage.verifyAboutDialogVisibility(),
      onboardingPage.swipeOnePage(),
      () => tester.pumpAndSettle(),
      proVerionOfferPage.verifyProVersionIsAvailable(),
      // Buying PRO version, verifying that PRO MODE is applied on the HomePage
      proVerionOfferPage.buyPRO(),
      onboardingPage.skipPages(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyProVersionScreen(),
    ],
  )();
}
