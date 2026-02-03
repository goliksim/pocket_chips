import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class SolverPageTester {
  final WidgetTester tester;

  SolverPageTester(this.tester);

  Future<void> verifyIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(SolverKeys.page), findsOneWidget);
  }
}
