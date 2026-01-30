import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';
import 'package:pocket_chips/services/monitization/purchases/models/pro_version_model.dart';
import 'package:pocket_chips/services/monitization/purchases/models/purchasable_product.dart';

import '../mocks/pro_version_manager_mock.dart';
import '../pages/home_page.dart';
import '../pages/onboarding_page.dart';
import '../pages/pro_version_offer_page.dart';

/// [ProVersionTest]
/// No cached PRO mode, didn't restore from store (force disable)
/// Checking Pro Mode during onboarding and on HomePage
Future<void> runProVersionTest5(
  WidgetTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: true,
    locale: 'en',
    version: '2.0.0',
  );
  // Создаем мок-состояние с купленной PRO версией

  final restoredState = ProVersionModel(
    forceDisable: true,
    isPurchased: false,
    availableProduct: PurchasableProduct(
      ProductDetails(
        id: 'test',
        title: 'Test title',
        description: 'Test description',
        price: '100 rub',
        rawPrice: 100,
        currencyCode: 'ru',
      ),
    ),
  );

  // Создаем мок-менеджер с начальным состоянием и состоянием после restorePurchases
  final mockManager = MockProVersionManager(
    restoredState: restoredState,
  );

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
        proVersionManagerProvider.overrideWith(() => mockManager),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final onboardingPage = OnboardingPageTester(tester);

  await onboardingPage.verifyAboutDialogIsVisible();
  await onboardingPage.swipePage();

  await tester.pumpAndSettle(Duration(seconds: 3));
  final proVerionOfferPage = ProVersionOfferPageTester(tester);
  await proVerionOfferPage.verifyProVersionIsAvailable();

  await onboardingPage.tapSkipButton();
  await onboardingPage.closeOnboardingDialog();

  final homePage = HomePageTester(tester);

  await homePage.verifyIsNotProVersionScreen();
}
