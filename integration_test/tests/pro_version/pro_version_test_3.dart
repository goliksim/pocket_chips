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
/// Сached PRO mode, store not available
/// Checking Pro Mode during onboarding and on HomePage
Future<void> runProVersionTest3(
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
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.offline);

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
      () => tester.pumpAndSettle(),
      onboardingPage.verifyAboutDialogVisibility(),
      // Verify PRO MODE is purchased but store is offline, check PRO is applied at the HomePage
      () => tester.pump(const Duration(seconds: 5)),
      onboardingPage.swipeOnePage(),
      proVerionOfferPage.verifyProVersionIsPurchased(),
      onboardingPage.skipPages(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyProVersionScreen(),
    ],
  )();
}
