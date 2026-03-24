import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class GameSettingsDialogTester {
  final PatrolTester $;

  GameSettingsDialogTester(this.$);

  TAction verifyVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameSettingsKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterStartingStack(String text) =>
      () => $(GameSettingsKeys.stackField).enterText(text);

  TAction enterSmallBlind(String text) =>
      () => $(GameSettingsKeys.smallBlindField).enterText(text);

  TAction verifyAllowCustomBetsValue(bool expectedValue) => () async {
        await $.tester.pumpAndSettle();

        final checkbox = $.tester.widget<Checkbox>(
          find.byKey(GameSettingsKeys.allowCustomBetsCheckbox),
        );

        expect(checkbox.value, expectedValue);
      };

  TAction toggleAllowCustomBets() =>
      () => $(GameSettingsKeys.allowCustomBetsCheckbox).tap();

  TAction saveChangesAndExit() => () => $(GameSettingsKeys.confirmButton).tap();
}
