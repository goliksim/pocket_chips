import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/services/monitization/purchases/models/pro_version_model.dart';

import '../initialization_tests.mocks.dart';
import '../pages/home_page.dart';
import '../pages/onboarding_page.dart';

/// [InitializationTest]
/// Checking the patch note display for launch
/// Closing
Future<void> runInitialization2(
  WidgetTester tester,
  MockAppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: false,
    locale: 'en',
    version: '1.5.2',
  );

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appRepositoryProvider.overrideWithValue(repository),
        proVersionManagerProvider.overrideWithBuild(
          (_, __) async => ProVersionModel(),
        )
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();

  final onboardingPage = OnboardingPageTester(tester);

  await onboardingPage.verifyUpdateDialogIsVisible();

  await onboardingPage.closeUpdateDialog();

  final homePage = HomePageTester(tester);
  await homePage.verifyHomePageIsVisible();
}
