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

/// [MonitizationTest]
/// Not cached PRO mode
/// Loading video ad and items at the same time
/// Buying PRO
Future<void> runMonitizationTest1(
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
      MockPurchasesRepository(hasPurchasesForRestore: false)
        ..setScenario(MockScenario.success);
  final mockGoogleAdsManager = MockGoogleAdsManager();

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );
  when(repository.isProVersion()).thenAnswer(
    (_) async => false,
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
  await donationPage.verifyProMode(isPurchased: false);
  await donationPage.verifyVideoAd();

  await donationPage.buyProMode();

  await tester.pumpAndSettle();
  await donationPage.verifyVideoAd();
  await donationPage.verifyProMode(isPurchased: true);

  await CommonTester.closeDialog(tester);
  await homePage.verifyIsProVersionScreen();
}
