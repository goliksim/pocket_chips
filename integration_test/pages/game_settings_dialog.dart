import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class GameSettingsDialogTester {
  final WidgetTester tester;

  GameSettingsDialogTester(this.tester);

  TAction verifyIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameSettingsKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterStartingStack(String text) => () async {
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(GameSettingsKeys.stackField), text);
      };

  TAction enterSmallBlind(String text) => () async {
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byKey(GameSettingsKeys.smallBlindField), text);
      };

  TAction saveChanges() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameSettingsKeys.confirmButton));
      };
}
