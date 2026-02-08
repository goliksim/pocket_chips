import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

import '../test_utils/test_action.dart';

class PlayerEditorTester {
  final WidgetTester tester;

  PlayerEditorTester(this.tester);

  TAction verifyIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyAvatarSelectorIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.avatarSelectorDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction enterName(String text) => () async {
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byKey(PlayerEditorKeys.usernameField), text);
      };

  TAction enterBank(String text) => () async {
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(PlayerEditorKeys.bankField), text);
      };

  TAction toggleDealer() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(PlayerEditorKeys.dealerCheckbox));
      };

  TAction tapConfirmButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(PlayerEditorKeys.confirmButton));
      };

  TAction tapAvatar() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(PlayerEditorKeys.editorAvatar));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      };

  TAction selectAvatar(int index) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(PlayerEditorKeys.selectableAvatar(index)));
        await tester.pumpAndSettle(const Duration(seconds: 1));
      };

  TAction verifyAvatarByAssetUrl(String assetUrl) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(PlayerEditorKeys.avatarKeyByAsset(assetUrl)),
          findsOneWidget,
        );
      };
}
