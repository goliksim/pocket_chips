import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/pro_version/pro_version_model.dart';
import 'package:pocket_chips/domain/repositories/app_repository.dart';

import '../../pages/home_page.dart';
import '../../pages/onboarding_page.dart';
import '../../test_utils/test_action.dart';

/// [InitializationTest]
/// Checking the onboarding display for the first launch
/// Skip pages, check the patch notes, and close
Future<void> runInitialization1(
  WidgetTester tester,
  AppRepository repository,
) async {
  final mockConfig = ConfigModel(
    isDark: false,
    firstLaunch: true,
    locale: 'en',
    version: '2.0.0',
  );

  when(repository.getConfig()).thenAnswer(
    (_) async => mockConfig,
  );

  final onboardingPage = OnboardingPageTester(tester);
  final homePage = HomePageTester(tester);

  await runAction(
    () => tester.pumpWidget(
      ProviderScope(
        overrides: [
          appRepositoryProvider.overrideWithValue(repository),
          proVersionManagerProvider.overrideWithBuild(
            (_, __) async => ProVersionModel(),
          )
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
      onboardingPage.verifyAboutDialogIsVisible(),
      onboardingPage.tapSkipButton(),
      onboardingPage.tapUpdateInfoButton(),
      onboardingPage.verifyUpdateDialogIsVisible(),
      onboardingPage.closeUpdateDialog(),
      onboardingPage.closeOnboardingDialog(),
      homePage.verifyHomePageIsVisible(),
    ],
  )();
}
