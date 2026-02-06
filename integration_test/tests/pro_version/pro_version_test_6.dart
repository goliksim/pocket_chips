import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../mocks/purchases_repository_mock.dart';
import '../../pages/home_page.dart';
import '../../pages/onboarding_page.dart';
import '../../pages/pro_version_offer_page.dart';

/// [ProVersionTest]
/// No cached PRO mode, store is unavailable
/// Closing onboarding, returning with connection, restore PRO MODE
/// Checking Pro Mode during onboarding and on HomePage
Future<void> runProVersionTest6(
  WidgetTester tester,
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
    (_) async => false,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        proVersionRepository.overrideWithValue(mockPurchasesRepository),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final onboardingPage = OnboardingPageTester(tester);

  await onboardingPage.verifyAboutDialogIsVisible();
  await onboardingPage.swipePage();

  await tester.pumpAndSettle();

  final proVerionOfferPage = ProVersionOfferPageTester(tester);
  await proVerionOfferPage.verifyProVersionIsNotAvailable();

  await onboardingPage.tapSkipButton();
  await onboardingPage.closeOnboardingDialog();

  final homePage = HomePageTester(tester);

  await homePage.verifyIsNotProVersionScreen();

  // Turning on connection
  mockPurchasesRepository.setScenario(MockScenario.success);

  await homePage.tapHelpButton();
  await onboardingPage.verifyAboutDialogIsVisible();
  await onboardingPage.swipePage();

  await tester.pumpAndSettle();
  await proVerionOfferPage.verifyProVersionIsAvailable();
  await proVerionOfferPage.tapBuyPROButton();

  await onboardingPage.tapSkipButton();
  await onboardingPage.closeOnboardingDialog();

  await homePage.verifyIsProVersionScreen();
}
