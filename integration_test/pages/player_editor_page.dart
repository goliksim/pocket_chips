import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class PlayerEditorTester {
  final WidgetTester tester;

  PlayerEditorTester(this.tester);

  Future<void> verifyIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(PlayerEditorKeys.dialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyAvatarSelectorIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(PlayerEditorKeys.avatarSelectorDialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> enterName(String text) async {
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(PlayerEditorKeys.usernameField), text);
  }

  Future<void> enterBank(String text) async {
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(PlayerEditorKeys.bankField), text);
  }

  Future<void> toggleDealer() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PlayerEditorKeys.dealerCheckbox));
  }

  Future<void> tapConfirmButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PlayerEditorKeys.confirmButton));
  }

  Future<void> tapAvatar() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PlayerEditorKeys.editorAvatar));
    await tester.pumpAndSettle(Duration(seconds: 1));
  }

  Future<void> selectAvatar(int index) async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PlayerEditorKeys.selectableAvatar(index)));
    await tester.pumpAndSettle(Duration(seconds: 1));
  }

  Future<void> verifyAvatarByAssetUrl(String assetUrl) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(PlayerEditorKeys.avatarKeyByAsset(assetUrl)),
      findsOneWidget,
    );
  }
}
