import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

abstract class CommonTester {
  static TAction closeDialog(WidgetTester tester) => () async {
        await tester.pumpAndSettle();

        final screen = Offset(
          tester.view.physicalSize.width / tester.view.devicePixelRatio,
          tester.view.physicalSize.height / tester.view.devicePixelRatio,
        );

        final point = Offset(screen.dx * 0.5, screen.dy * 0.9);

        await tester.tapAt(point);
      };

  static TAction closePage(WidgetTester tester) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(CommonKeys.closePageButton));
      };

  static TAction systemClosePage(WidgetTester tester) => () async {
        await tester.pumpAndSettle();

        if (Platform.isAndroid) {
          await tester.binding.handlePopRoute();
          return;
        }
        return closePage(tester)();
      };

  static TAction systemCloseDialog(WidgetTester tester) => () async {
        await tester.pumpAndSettle();

        if (Platform.isAndroid) {
          await tester.binding.handlePopRoute();
          return;
        }
        return closeDialog(tester)();
      };
}
