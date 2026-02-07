import 'package:flutter/material.dart';
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
      find.byKey(GameSettingsKeys.dialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifySmallBlind(int smallBlind) async {
    await tester.pumpAndSettle();

    expect(find.byKey(GameKeys.blinds(smallBlind)), findsOneWidget);
  }

  Future<void> verifyPlayerBank({
    required String name,
    required int expectedBank,
  }) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameTableKeys.playerBank(name, expectedBank)),
      findsOneWidget,
    );
  }

  Future<void> verifyPlayerBet({
    required String name,
    required int expectedBet,
  }) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameTableKeys.playerBet(name, expectedBet)),
      findsOneWidget,
    );
  }

  Future<void> verifyCurrentPlayer(
    String name, {
    bool isVisible = true,
  }) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameTableKeys.currentPlayerMarker(name)),
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
      case GameStatusEnum.showdown:
        _verifyGameStatusShowdown();
        break;
      default:
        throw UnimplementedError();
    }
  }

  Future<void> tapUndoActionButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameKeys.undoButton));
  }

  Future<void> verifyUndoButtonIsVisible() async {
    await tester.pumpAndSettle();

    expect(find.byKey(GameKeys.undoButton), findsOneWidget);
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

  Future<void> tapRaiseButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.raiseButton));
  }

  Future<void> tapCallButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.callButton));
  }

  Future<void> tapAllInButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.allInButton));
  }

  Future<void> tapFoldButton() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.foldButton));
  }

  Future<void> tapRaiseCancel() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.raiseCancelButton));
  }

  Future<void> tapRaiseConfirm() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.raiseConfirmButton));
  }

  Future<void> tapRaiseChip(int value) async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameControlKeys.raiseChip(value)));
  }

  Future<int> getRaiseSliderValue() async {
    await tester.pumpAndSettle();

    final slider =
        tester.widget<Slider>(find.byKey(GameControlKeys.raiseSlider));
    return slider.value.toInt();
  }

  Future<void> dragRaiseSliderToMax() async {
    await tester.pumpAndSettle();

    final sliderFinder = find.byKey(GameControlKeys.raiseSlider);
    await tester.drag(sliderFinder, const Offset(300, 0));
    await tester.pumpAndSettle();
  }

  Future<void> verifyRaiseFieldVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameControlKeys.raiseField),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyRaiseMinMax({
    required String minValue,
    required String maxValue,
  }) async {
    await tester.pumpAndSettle();

    final minText =
        tester.widget<Text>(find.byKey(GameControlKeys.raiseMinLabel)).data ??
            '';
    final maxText =
        tester.widget<Text>(find.byKey(GameControlKeys.raiseMaxLabel)).data ??
            '';

    expect(minText, minValue);
    expect(maxText, maxValue);
  }

  Future<void> verifyAddMainButtonVisible(bool isVisible) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(GameTableKeys.addMainButton),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> _openAddMenu() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(GameTableKeys.addMainButton));
  }

  Future<void> tapAddNewPlayerButton() async {
    await tester.pumpAndSettle();

    var finder = find.byKey(GameTableKeys.addNewPlayerButton);

    if (!finder.hasFound) {
      await _openAddMenu();

      await tester.pumpAndSettle();
      finder = find.byKey(GameTableKeys.addNewPlayerButton);
    }
    await tester.tap(finder);
  }

  Future<void> tapAddSavedPlayerButton() async {
    await tester.pumpAndSettle();

    var finder = find.byKey(GameTableKeys.addSavedPlayerButton);
    if (!finder.hasFound) {
      await _openAddMenu();

      await tester.pumpAndSettle();
      finder = find.byKey(GameTableKeys.addSavedPlayerButton);
    }

    await tester.tap(finder);
  }

  Future<void> verifyWinnerDialogVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(WinnerKeys.winnerDialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> verifyWinnerChoiceDialogVisible({bool isVisible = true}) async {
    await tester.pumpAndSettle();

    expect(
      find.byKey(WinnerKeys.winnerChoiceDialog),
      isVisible ? findsOneWidget : findsNothing,
    );
  }

  Future<void> selectWinner(String uid) async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WinnerKeys.winnerChoiceCheckbox(uid)));
  }

  Future<void> confirmWinnerChoice() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WinnerKeys.winnerChoiceConfirmButton));
  }

  Future<void> tapWinnerDialog() async {
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(WinnerKeys.winnerDialog));
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

  Future<void> _verifyGameStatusShowdown() async {
    expect(
      find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.showdown)),
      findsOneWidget,
    );
  }
}
