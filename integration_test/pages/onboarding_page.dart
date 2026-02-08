import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class OnboardingPageTester {
  final WidgetTester tester;

  OnboardingPageTester(this.tester);

  TAction verifyAboutDialogIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(OnboardingKeys.aboutDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction tapSkipButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(OnboardingKeys.skipButton));
      };

  TAction swipePage() => () async {
        await tester.pumpAndSettle();

        final screen = Offset(
          tester.view.physicalSize.width / tester.view.devicePixelRatio,
          tester.view.physicalSize.height / tester.view.devicePixelRatio,
        );

        final start = Offset(screen.dx * 0.85, screen.dy / 2);
        final offset = Offset(screen.dx * -0.85, 0);

        await tester.dragFrom(
          start,
          offset,
        );
      };

  TAction tapUpdateInfoButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(OnboardingKeys.showUpdateDialogButton));
      };

  TAction verifyUpdateDialogIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(OnboardingKeys.updateDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction closeUpdateDialog() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(OnboardingKeys.closeUpdateDialogButton));
      };

  TAction closeOnboardingDialog() => () async {
        await tester.pumpAndSettle(const Duration(seconds: 1));

        await tester.tap(find.byKey(OnboardingKeys.closeAboutDialogButton));
      };
}
