import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/google_ads_manager_mock.dart' hide MockScenario;
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/donation_page.dart';
import '../../pages/home_page.dart';
import '../../test_utils/test_action.dart';

/// [MonitizationTest]
/// Cached PRO mode
/// Loading video ad before items
Future<void> runMonitizationTest3(
  PatrolTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: false,
    locale: 'en',
    version: '2.0.0',
  );

  final mockPurchasesRepository = MockPurchasesRepository(
    hasPurchasesForRestore: true,
    loadingTime: Duration(seconds: 2),
  )..setScenario(MockScenario.success);
  final mockGoogleAdsManager = MockGoogleAdsManager();

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
      // Open donation page and check video ad is loaded immediately and PRO mode is not loaded
      homePage.openDonationPage(),
      () => tester.pump(const Duration(seconds: 1)), //Dialog opening
      donationPage.verifyVisibility(),
      donationPage.verifyVideoAdItemExist(isLoaded: true),
      donationPage.verifyProModeItemExist(isPurchased: true, exist: false),
      // Verify video ad is loaded and PRO mode is active after loading time
      () => tester.pump(const Duration(seconds: 3)),
      donationPage.verifyVideoAdItemExist(isLoaded: true),
      donationPage.verifyProModeItemExist(isPurchased: true),
    ],
  )();
}
