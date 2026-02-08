import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class BankEditorDialogTester {
  final WidgetTester tester;

  BankEditorDialogTester(this.tester);

  TAction verifyIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(BankEditorKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterStack(String text) => () async {
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(BankEditorKeys.textField), text);
      };

  TAction confirm() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(BankEditorKeys.confirmButton));
      };
}
