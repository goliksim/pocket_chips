import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/application.dart';
import 'package:pocket_chips/di/domain_managers.dart';
import 'package:pocket_chips/di/repositories.dart';
import 'package:pocket_chips/domain/models/config_model.dart';
import 'package:pocket_chips/domain/models/pro_version/pro_version_model.dart';

import '../../initialization_test.mocks.dart';
import '../../pages/home_page.dart';
import '../../pages/onboarding_page.dart';
import '../../test_utils/test_action.dart';

/// [InitializationTest]
/// Checking the patch note display for launch
/// Closing
Future<void> runInitialization2(
  PatrolTester tester,
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

  final onboardingPage = OnboardingPageTester(tester);
  final homePage = HomePageTester(tester);
  await runAction(
    () => tester.pumpWidgetAndSettle(
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
      // Wait for update patchnote to load
      onboardingPage.verifyUpdateDialogVisibility(),
      onboardingPage.closeUpdateInfoDialog(),
      homePage.verifyHomePageVisibility(),
    ],
  )();
}
