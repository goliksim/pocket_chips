import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class BankEditorDialogTester {
  final PatrolTester $;

  BankEditorDialogTester(this.$);

  TAction verifyVisibility({bool isVisible = true}) => () async {
        await $.pumpAndSettle();

        expect(
          find.byKey(BankEditorKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterInitialStack(String text) =>
      () => $(BankEditorKeys.textField).enterText(text);

  TAction confirmAndExit() => () => $(BankEditorKeys.confirmButton).tap();
}
