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
import '../../pages/common_tester.dart';
import '../../pages/donation_page.dart';
import '../../pages/home_page.dart';
import '../../test_utils/test_action.dart';

/// [MonitizationTest]
/// Not cached PRO mode
/// Loading video ad and items at the same time
/// Restoring PRO
Future<void> runMonitizationTest5(
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
        ..setScenario(MockScenario.offline);

  final mockGoogleAdsManager = MockGoogleAdsManager();

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => false,
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
      // Open home page and tap donation button
      () => tester.pumpAndSettle(),
      () async => mockPurchasesRepository.setScenario(MockScenario.success),
      homePage.tapDonationButton(),
      () => tester.pump(const Duration(seconds: 1)), //Dialog opening
      donationPage.verifyIsVisible(),
      // Verify PRO mode is not purchased, video ad is visible
      donationPage.verifyProMode(isPurchased: false),
      donationPage.verifyVideoAd(),
      // Tap restore purchases and verify PRO mode is purchased and video ad is visible
      donationPage.restorePurchases(),
      () => tester.pumpAndSettle(),
      donationPage.verifyVideoAd(),
      donationPage.verifyProMode(isPurchased: true),
      // Close dialog and verify PRO version is applied on home page
      CommonTester.closeDialog(tester),
      homePage.verifyIsProVersionScreen(),
    ],
  )();
}
