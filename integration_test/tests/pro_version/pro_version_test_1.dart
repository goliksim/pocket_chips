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
/// Cached PRO mode, store is available and returned PRO MODE
/// Restored from store
Future<void> runProVersionTest1(
  PatrolTester tester,
  AppRepository repository,
) async {
  final mockConfig = (await defaultConfig()).copyWith(
    firstLaunch: true,
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
      // Verify PRO version is purchased and applyed on the HomePage
      onboardingPage.swipeOnePage(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 3)),
      proVerionOfferPage.verifyProVersionIsPurchased(),
      onboardingPage.skipPages(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyProVersionScreen(),
    ],
  )();
}
