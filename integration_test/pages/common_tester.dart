import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

abstract class CommonTester {
  static TAction closeDialog(PatrolTester $) => () async {
        await $.pumpAndSettle();

        final screen = Offset(
          $.tester.view.physicalSize.width / $.tester.view.devicePixelRatio,
          $.tester.view.physicalSize.height / $.tester.view.devicePixelRatio,
        );

        final point = Offset(screen.dx * 0.5, screen.dy * 0.9);

        await $.tester.tapAt(point);
      };

  static TAction closePage(PatrolTester $) =>
      () => $(CommonKeys.closePageButton).tap();

  static TAction systemClosePage(PatrolTester $) => () async {
        await $.tester.pumpAndSettle();

        if (Platform.isAndroid) {
          await $.tester.binding.handlePopRoute();
          return;
        }
        return closePage($)();
      };

  static TAction systemCloseDialog(PatrolTester $) => () async {
        await $.tester.pumpAndSettle();

        if (Platform.isAndroid) {
          await $.tester.binding.handlePopRoute();
          return;
        }
        return closeDialog($)();
      };
}

extension PatrolTesterX on PatrolFinder {
  Future<void> tapPROWidget({
    Duration settleTimeout = const Duration(milliseconds: 100),
  }) =>
      TestAsyncUtils.guard(
        () => wrapWithPatrolLog(
          action: 'PRO wrapped tap',
          color: '\u001b[36m',
          function: () async {
            await tester.pumpAndSettle();
            await tester.tester.tap(this);
            await tester.pumpAndSettle(duration: settleTimeout);
          },
        ),
      );

  Future<void> tapAnimated({
    Duration settleTimeout = const Duration(milliseconds: 100),
  }) =>
      TestAsyncUtils.guard(
        () => wrapWithPatrolLog(
          action: 'tap animated',
          color: '\u001b[33m',
          function: () async {
            await tester.pumpAndSettle(duration: settleTimeout);
            await tester.tester.tap(this);
            await tester.pumpAndSettle();
          },
        ),
      );
}
