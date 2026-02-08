import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';

import '../test_utils/test_action.dart';

class GamePageTester {
  final WidgetTester tester;

  GamePageTester(this.tester);

  TAction verifyIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.page),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifySettingsIsVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameSettingsKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifySmallBlind(int smallBlind) => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(GameKeys.blinds(smallBlind)), findsOneWidget);
      };

  TAction verifyPlayerBank({
    required String name,
    required int expectedBank,
  }) =>
      () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.playerBank(name, expectedBank)),
          findsOneWidget,
        );
      };

  TAction findPlayerCard(String name, {bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.playerCard(name)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyPlayerBet({
    required String name,
    required int expectedBet,
  }) =>
      () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.playerBet(name, expectedBet)),
          findsOneWidget,
        );
      };

  TAction verifyCurrentPlayer(
    String name, {
    bool isVisible = true,
  }) =>
      () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.currentPlayerMarker(name)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyGameStatus(GameStatusEnum status) => () async {
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
      };

  TAction tapUndoActionButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameKeys.undoButton));
      };

  TAction verifyUndoButtonIsVisible() => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(GameKeys.undoButton), findsOneWidget);
      };

  TAction verifyUndoButtonIsNotVisible() => () async {
        await tester.pumpAndSettle();

        expect(find.byKey(GameKeys.undoButton), findsNothing);
      };

  TAction startGame() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameKeys.startGameButton));
      };

  TAction tapSettingsButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameKeys.settingsButton));
      };

  TAction tapRaiseButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.raiseButton));
      };

  TAction tapCallButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.callButton));
      };

  TAction tapAllInButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.allInButton));
      };

  TAction tapFoldButton() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.foldButton));
      };

  TAction tapRaiseCancel() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.raiseCancelButton));
      };

  TAction tapRaiseConfirm() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.raiseConfirmButton));
      };

  TAction tapRaiseChip(int value) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameControlKeys.raiseChip(value)));
      };

  Future<int> getRaiseSliderValue() async {
    await tester.pumpAndSettle();

    final slider =
        tester.widget<Slider>(find.byKey(GameControlKeys.raiseSlider));
    return slider.value.toInt();
  }

  TAction dragRaiseSliderToMax() => () async {
        await tester.pumpAndSettle();

        final sliderFinder = find.byKey(GameControlKeys.raiseSlider);
        await tester.drag(sliderFinder, const Offset(300, 0));
        await tester.pumpAndSettle();
      };

  TAction verifyRaiseFieldVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameControlKeys.raiseField),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyRaiseMinMax({
    required String minValue,
    required String maxValue,
  }) =>
      () async {
        await tester.pumpAndSettle();

        final minText = tester
                .widget<Text>(find.byKey(GameControlKeys.raiseMinLabel))
                .data ??
            '';
        final maxText = tester
                .widget<Text>(find.byKey(GameControlKeys.raiseMaxLabel))
                .data ??
            '';

        expect(minText, minValue);
        expect(maxText, maxValue);
      };

  TAction verifyAddMainButtonVisible(bool isVisible) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.addMainButton),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction _openAddMenu() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(GameTableKeys.addMainButton));
      };

  TAction tapAddNewPlayerButton() => () async {
        await tester.pumpAndSettle();

        var finder = find.byKey(GameTableKeys.addNewPlayerButton);

        if (!finder.hasFound) {
          await _openAddMenu()();

          await tester.pumpAndSettle();
          finder = find.byKey(GameTableKeys.addNewPlayerButton);
        }
        await tester.tap(finder);
      };

  TAction tapAddSavedPlayerButton() => () async {
        await tester.pumpAndSettle();

        var finder = find.byKey(GameTableKeys.addSavedPlayerButton);
        if (!finder.hasFound) {
          await _openAddMenu()();

          await tester.pumpAndSettle();
          finder = find.byKey(GameTableKeys.addSavedPlayerButton);
        }

        await tester.tap(finder);
      };

  TAction verifyWinnerDialogVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(WinnerKeys.winnerDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyWinnerChoiceDialogVisible({bool isVisible = true}) => () async {
        await tester.pumpAndSettle();

        expect(
          find.byKey(WinnerKeys.winnerChoiceDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction selectWinner(String uid) => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(WinnerKeys.winnerChoiceCheckbox(uid)));
      };

  TAction confirmWinnerChoice() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(WinnerKeys.winnerChoiceConfirmButton));
      };

  TAction tapWinnerDialog() => () async {
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(WinnerKeys.winnerDialog));
      };

  void _verifyGameStatusNotStarted() {
    expect(find.byKey(GameKeys.startGameButton), findsOneWidget);
    expect(
      find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.notStarted)),
      findsOneWidget,
    );
  }

  void _verifyGameStatusPreFlop() => expect(
        find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.preFlop)),
        findsOneWidget,
      );

  void _verifyGameStatusShowdown() => expect(
        find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.showdown)),
        findsOneWidget,
      );
}
