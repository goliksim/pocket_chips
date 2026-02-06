import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class BankEditorDialogTester {
  final WidgetTester tester;

  BankEditorDialogTester(this.tester);

  Future<void> verifyIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(BankEditorKeys.dialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> enterStack(String text) async {
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(BankEditorKeys.textField), text);
  }

  Future<void> confirm() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(BankEditorKeys.confirmButton));
  }
}
