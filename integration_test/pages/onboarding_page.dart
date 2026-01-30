import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class OnboardingPageTester {
  final WidgetTester tester;

  OnboardingPageTester(this.tester);

  Future<void> verifyAboutDialogIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingKeys.aboutDialog), findsOneWidget);
  }

  Future<void> tapSkipButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OnboardingKeys.skipButton));
  }

  Future<void> swipePage() async {
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
  }

  Future<void> tapUpdateInfoButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OnboardingKeys.showUpdateDialogButton));
  }

  Future<void> verifyUpdateDialogIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingKeys.updateDialog), findsOneWidget);
  }

  Future<void> closeUpdateDialog() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OnboardingKeys.closeUpdateDialogButton));
  }

  Future<void> closeOnboardingDialog() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(OnboardingKeys.closeAboutDialogButton));
  }
}
