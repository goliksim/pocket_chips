import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/google_ads_manager_mock.dart' as ad;
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/donation_page.dart';
import '../../pages/home_page.dart';
import '../../test_utils/test_action.dart';
import '../../test_utils/test_utils.dart';

/// [MonitizationTest]
/// Cached PRO mode
/// No internet connection
Future<void> runMonitizationTest4(
  PatrolTester tester,
  AppRepository repository,
) async {
  final mockConfig = await defaultConfig();

  final mockPurchasesRepository = MockPurchasesRepository(
    hasPurchasesForRestore: true,
  )..setScenario(MockScenario.offline);
  final mockGoogleAdsManager = ad.MockGoogleAdsManager()
    ..setScenario(ad.MockScenario.offline);

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );

  final homePage = HomePageTester(tester);
  final donationPage = DonationPageTester(tester);

  await runAction(
    () => tester.pumpWidgetAndSettle(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(repository),
          purchasesRepositoryProvider
              .overrideWithValue(mockPurchasesRepository),
          proVersionRepositoryProvider.overrideWithValue(
            mockPurchasesRepository,
          ),
          googleAdsManagerProvider.overrideWith(() => mockGoogleAdsManager),
        ],
        child: const MyApp(),
      ),
    ),
  );

  // Run test actions
  await runTestActions(
    [
      // Open donation page and check error messages
      homePage.openDonationPage(),
      () => tester.pumpAndSettle(
          duration: const Duration(seconds: 1)), //Dialog opening
      donationPage.verifyVisibility(),
      donationPage.verifyUnavailableState(),
      // Retry loading and verify error messages are still shown
      donationPage.retry(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 1)),
      donationPage.verifyVisibility(),
      donationPage.verifyUnavailableState(),
      () async {
        // Set repositories to success scenario to simulate internet connection restoration
        mockPurchasesRepository.setScenario(MockScenario.success);
        mockGoogleAdsManager.setScenario(ad.MockScenario.success);
      },
      // Retry loading and verify PRO mode is active and video ad is loaded
      donationPage.retry(),
      () => tester.pumpAndSettle(duration: const Duration(seconds: 3)),
      donationPage.verifyProModeItemLoaded(isPurchased: true),
      donationPage.verifyVideoAdItemLoaded(isLoaded: true),
    ],
  )();
}
