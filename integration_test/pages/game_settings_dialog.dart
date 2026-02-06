import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';

class GameSettingsDialogTester {
  final WidgetTester tester;

  GameSettingsDialogTester(this.tester);

  Future<void> verifyIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameSettingsKeys.dialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> enterStartingStack(String text) async {
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(GameSettingsKeys.stackField), text);
  }

  Future<void> enterSmallBlind(String text) async {
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(GameSettingsKeys.smallBlindField), text);
  }

  Future<void> saveChanges() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameSettingsKeys.confirmButton));
  }
}
