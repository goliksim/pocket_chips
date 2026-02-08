import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
/// Loading video ad after and items
Future<void> runMonitizationTest2(
  WidgetTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: false,
    locale: 'en',
    version: '2.0.0',
  );

  final mockPurchasesRepository =
      MockPurchasesRepository(hasPurchasesForRestore: true)
        ..setScenario(MockScenario.success);
  final mockGoogleAdsManager = MockGoogleAdsManager(
    loadingTime: Duration(seconds: 2),
  );

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );

  final homePage = HomePageTester(tester);
  final donationPage = DonationPageTester(tester);

  await runAction(
    () => tester.pumpWidget(
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
      // Open donation page, verify PRO mode is active and video ad is loading
      () => tester.pumpAndSettle(),
      homePage.tapDonationButton(),
      () => tester.pump(const Duration(seconds: 1)), //Dialog opening
      donationPage.verifyIsVisible(),
      donationPage.verifyVideoAd(isLoaded: false),
      () => tester.pumpAndSettle(),
      donationPage.verifyProMode(isPurchased: true),
      () => tester.pumpAndSettle(),
      // Verify video ad is loaded after loading time
      donationPage.verifyVideoAd(isLoaded: true),
      donationPage.verifyProMode(isPurchased: true),
    ],
  )();
}
