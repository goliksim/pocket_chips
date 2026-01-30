import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class HomePageTester {
  final WidgetTester tester;

  HomePageTester(this.tester);

  Future<void> verifyHomePageIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(HomeKeys.page), findsOneWidget);
  }

  Future<void> verifyIsProVersionScreen() async {
    await tester.pumpAndSettle();

    expect(find.byKey(ProVersionKeys.proVersionBlockWrapper), findsNothing);
  }

  Future<void> verifyIsNotProVersionScreen() async {
    await tester.pumpAndSettle();

    expect(find.byKey(ProVersionKeys.proVersionBlockWrapper), findsAtLeast(1));
  }

  Future<void> tapHelpButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(HomeKeys.helpButton));
  }
}
