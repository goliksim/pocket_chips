import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';
import 'common_tester.dart';

class PlayerEditorTester {
  final PatrolTester $;

  PlayerEditorTester(this.$);

  TAction verifyVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyAvatarPickerVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.avatarSelectorDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterName(String text) =>
      () => $(PlayerEditorKeys.usernameField).enterText(text);

  TAction enterBank(String text) =>
      () => $(PlayerEditorKeys.bankField).enterText(text);

  TAction toggleDealer() => () => $(PlayerEditorKeys.dealerCheckbox).tap();

  TAction confirmEditingAndExit() =>
      () => $(PlayerEditorKeys.confirmButton).tap();

  TAction openAvatarPicker() =>
      () => $(PlayerEditorKeys.editorAvatar).tapPROWidget(
            settleTimeout: Duration(seconds: 1),
          );

  TAction selectAvatarByIndex(int index) => () async {
        await $(PlayerEditorKeys.selectableAvatar(index)).tap();

        await $.tester.pump(Duration(seconds: 1));
      };

  TAction verifyAvatarByAssetUrl(String assetUrl) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.avatarKeyByAsset(assetUrl)),
          findsOneWidget,
        );
      };
}
