import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:pocket_chips/app/keys/keys.dart';
import 'package:pocket_chips/domain/models/game/game_state_enum.dart';

import '../test_utils/test_action.dart';
import 'common_tester.dart';

class GamePageTester {
  final PatrolTester $;

  GamePageTester(this.$);

  TAction verifyVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.page),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifySettingsVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameSettingsKeys.dialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifySmallBlindValues(int smallBlind) => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(GameKeys.blinds(smallBlind)), findsOneWidget);
      };

  TAction verifyPlayerBankValue({
    required String name,
    required int expectedBank,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.playerBank(name, expectedBank)),
          findsOneWidget,
        );
      };

  TAction verifyPlayerCard(String name, {bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.playerCard(name)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyPlayerBetValue({
    required String name,
    required int expectedBet,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

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
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.currentPlayerMarker(name)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyGameStatus(GameStatusEnum status) => () async {
        await $.tester.pumpAndSettle();

        switch (status) {
          case GameStatusEnum.notStarted:
            _verifyGameStatusNotStarted();
            break;
          case GameStatusEnum.gameBreak:
            _verifyGameStatusBreakdown();
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

  TAction undoLastAction() => () => $(GameKeys.undoButton).tapPROWidget();

  TAction verifyUndoButtonVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(find.byKey(GameKeys.undoButton),
            isVisible ? findsOneWidget : findsNothing);
      };

  TAction tapIncreaseLevel() =>
      () => $(GameKeys.increaseLevelButton).tapPROWidget();

  TAction verifyIncreaseLevelVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.increaseLevelButton),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction startGame() => () => $(GameKeys.startGameButton).tap();

  TAction openSettins() => () => $(GameKeys.settingsButton).tap();

  TAction raise() => () => $(GameControlKeys.raiseButton).tap();

  TAction call() => () => $(GameControlKeys.callButton).tap();

  TAction allIn() => () => $(GameControlKeys.allInButton).tap();

  TAction fold() => () => $(GameControlKeys.foldButton).tap();

  TAction cancelRaise() => () => $(GameControlKeys.raiseCancelButton).tap();

  TAction confirmRaise() => () async {
        await $.tester.pumpAndSettle();

        final normalButtonKey = find.byKey(
          GameControlKeys.raiseConfirmButton(),
        );
        final alertButtonKey = find.byKey(
          GameControlKeys.raiseConfirmButton(hasAlert: true),
        );

        final buttonKeyFinder = alertButtonKey.evaluate().isNotEmpty
            ? alertButtonKey
            : normalButtonKey;
        final buttonFinder = find.descendant(
          of: buttonKeyFinder,
          matching: find.byType(ElevatedButton),
        );

        await $(buttonFinder).tap();
      };

  TAction tapRaiseChip(int value) =>
      () => $(GameControlKeys.raiseChip(value)).tap();

  Future<int> getRaiseSliderValue() async {
    await $.tester.pumpAndSettle();

    final slider =
        $.tester.widget<Slider>(find.byKey(GameControlKeys.raiseSlider));
    return slider.value.toInt();
  }

  TAction verifyRaiseSliderValue(int expectedValue) => () async {
        expect(await getRaiseSliderValue(), expectedValue);
      };

  TAction dragRaiseSliderToMax() => () async {
        await $.tester.pumpAndSettle();

        final sliderFinder = find.byKey(GameControlKeys.raiseSlider);
        await $.tester.timedDrag(
          sliderFinder,
          const Offset(300, 0),
          Duration(seconds: 1),
        );
        await $.tester.pumpAndSettle();
      };

  TAction dragRaiseSliderToMin() => () async {
        await $.tester.pumpAndSettle();

        final sliderFinder = find.byKey(GameControlKeys.raiseSlider);
        await $.tester.timedDrag(
          sliderFinder,
          const Offset(-300, 0),
          Duration(seconds: 1),
        );
        await $.tester.pumpAndSettle();
      };

  TAction verifyRaiseConfirmButtonAlertState({
    required bool hasAlert,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameControlKeys.raiseConfirmButton(hasAlert: hasAlert)),
          findsOneWidget,
        );

        expect(
          find.byKey(GameControlKeys.raiseConfirmButton(hasAlert: !hasAlert)),
          findsNothing,
        );
      };

  TAction verifyRaiseFieldVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameControlKeys.raiseField),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyRaiseMinMaxValues({
    required String minValue,
    required String maxValue,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        final minText = $.tester
                .widget<Text>(find.byKey(GameControlKeys.raiseMinLabel))
                .data ??
            '';
        final maxText = $.tester
                .widget<Text>(find.byKey(GameControlKeys.raiseMaxLabel))
                .data ??
            '';

        expect(minText, minValue);
        expect(maxText, maxValue);
      };

  TAction verifyAddMainButtonVisibility(bool isVisible) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameTableKeys.addMainButton),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction _openAddMenu() => () => $(GameTableKeys.addMainButton).tap();

  TAction addNewPlayer() => () async {
        var finder = find.byKey(GameTableKeys.addNewPlayerButton);

        if (!finder.hasFound) {
          await _openAddMenu()();

          finder = find.byKey(GameTableKeys.addNewPlayerButton);
        }
        await $(finder).tap();
      };

  TAction openSavedList() => () async {
        var finder = find.byKey(GameTableKeys.addSavedPlayerButton);
        if (!finder.hasFound) {
          await _openAddMenu()();

          finder = find.byKey(GameTableKeys.addSavedPlayerButton);
        }

        await $(finder).tap();
      };

  TAction verifyWinnerDialogVisibility({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(WinnerKeys.winnerDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyWinnerChoiceDialogVisibility({bool isVisible = true}) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(WinnerKeys.winnerChoiceDialog),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction selectWinner(String uid) =>
      () => $(WinnerKeys.winnerChoiceCheckbox(uid)).tap();

  TAction confirmWinnerChoice() =>
      () => $(WinnerKeys.winnerChoiceConfirmButton).tap();

  TAction tapWinnerDialog() => () => $(WinnerKeys.winnerDialog).tap();

  TAction verifyProgressionVisible({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.progressionWidget),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyProgressionLevel(
    int level, {
    bool isVisible = true,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.progressionLevel(level)),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyProgressionSetupLabel({bool isVisible = true}) => () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.progressionSetupLabel),
          isVisible ? findsOneWidget : findsNothing,
        );
      };

  TAction verifyProgressionInterval(
    int value, {
    bool isVisible = true,
  }) =>
      () async {
        await $.tester.pumpAndSettle();

        expect(
          find.byKey(GameKeys.progressionIntervalValue(value)),
          isVisible ? findsOneWidget : findsNothing,
        );
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

  void _verifyGameStatusBreakdown() => expect(
        find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.gameBreak)),
        findsOneWidget,
      );

  void _verifyGameStatusShowdown() => expect(
        find.byKey(GameKeys.gameStatusTitle(GameStatusEnum.showdown)),
        findsOneWidget,
      );
}
