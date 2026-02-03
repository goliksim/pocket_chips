import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';

class GamePageTester {
  final WidgetTester tester;

  GamePageTester(this.tester);

  Future<void> verifyIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameKeys.page),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifySettingsIsVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(CommonKeys.settingsDialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyGameStatus(GameStatusEnum status) async {
    await tester.pumpAndSettle();

    switch (status) {
      case GameStatusEnum.notStarted:
        _verifyGameStatusNotStarted();
        break;
      case GameStatusEnum.preFlop:
        _verifyGameStatusPreFlop();
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> tapUndoActionButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameKeys.undoButton));
  }

  Future<void> verifyUndoButtonIsNotVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(GameKeys.undoButton), findsNothing);
  }

  Future<void> startGame() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameKeys.startGameButton));
  }

  Future<void> tapSettingsButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameKeys.settingsButton));
  }

  Future<void> _verifyGameStatusNotStarted() async {
    expect(find.byKey(GameKeys.startGameButton), findsOneWidget);
    expect(
      find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.notStarted)),
      findsOneWidget,
    );
  }

  Future<void> _verifyGameStatusPreFlop() async {
    expect(
      find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.preFlop)),
      findsOneWidget,
    );
  }
}
