import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/google_ads_manager_mock.dart' as ad;
import '../../mocks/purchases_repository_mock.dart';
import '../../pages/donation_page.dart';
import '../../pages/home_page.dart';

/// [MonitizationTest]
/// Cached PRO mode
/// No internet connection
Future<void> runMonitizationTest4(
  WidgetTester tester,
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
  )..setScenario(MockScenario.offline);
  final mockGoogleAdsManager = ad.MockGoogleAdsManager()
    ..setScenario(ad.MockScenario.offline);

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => true,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        purchasesRepositoryProvider.overrideWithValue(mockPurchasesRepository),
        proVersionRepositoryProvider.overrideWithValue(mockPurchasesRepository),
        googleAdsManagerProvider.overrideWith(() => mockGoogleAdsManager),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final homePage = HomePageTester(tester);
  final donationPage = DonationPageTester(tester);

  await homePage.tapDonationButton();

  await tester.pump(Duration(seconds: 1)); //Dialog opening
  await donationPage.verifyIsVisible();
  await donationPage.verifyUnavailable();

  await donationPage.retry();

  await tester.pump(Duration(seconds: 1));
  await donationPage.verifyIsVisible();
  await donationPage.verifyUnavailable();

  mockPurchasesRepository.setScenario(MockScenario.success);
  mockGoogleAdsManager.setScenario(ad.MockScenario.success);
  await donationPage.retry();

  await tester.pump(Duration(seconds: 4));
  await donationPage.verifyProMode(isPurchased: true);
  await donationPage.verifyVideoAd(isLoaded: true);
}
