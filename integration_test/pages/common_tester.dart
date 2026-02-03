import 'package:flutter_test/flutter_test.dart';

abstract class CommonTester {
  static Future<void> closeDialog(WidgetTester tester) async {
    await tester.pumpAndSettle();

    final screen = Offset(
      tester.view.physicalSize.width / tester.view.devicePixelRatio,
      tester.view.physicalSize.height / tester.view.devicePixelRatio,
    );

    final point = Offset(screen.dx * 0.5, screen.dy * 0.9);

    await tester.tapAt(point);
  }
}
