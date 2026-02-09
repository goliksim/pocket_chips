import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class OnboardingPageTester {
  final PatrolTester $;

  OnboardingPageTester(this.$);

  TAction verifyAboutDialogVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(OnboardingKeys.aboutDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction skipPages() => () async => $(OnboardingKeys.skipButton).tap();

  TAction swipeOnePage() => () async {
        await $.tester.pumpAndSettle();

        final screen = Offset(
          $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio,
          $.tester.view.physicalSize.height / $.tester.view.devicePixelRatio,
        );

        final start = Offset(screen.dx * 0.85, screen.dy / 2);
        final offset = Offset(screen.dx * -0.85, 0);

        await $.tester.dragFrom(
          start,
          offset,
        );
      };

  TAction openUpdateInfoDialog() =>
      () => $(OnboardingKeys.showUpdateDialogButton).tap();

  TAction verifyUpdateDialogVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(OnboardingKeys.updateDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction closeUpdateInfoDialog() =>
      () => $(OnboardingKeys.closeUpdateDialogButton).tap();

  TAction closeOnboardingDialog() =>
      () => $(OnboardingKeys.closeAboutDialogButton).tap();
}
