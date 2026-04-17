import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_page_control_state.freezed.dart';

@freezed
abstract class GamePageControlState with _$GamePageControlState {
  const factory GamePageControlState.active({
    required RaiseControlState raiseState,
    required MainControlState mainState,
  }) = GamePageActiveControlState;

  const factory GamePageControlState.breakdown({
    required bool canStartBetting,
    required bool canIncreaseLevel,
  }) = _GamePageControlBreakDownState;

  const factory GamePageControlState.showdown() = _GamePageControlShowDownState;
}

@freezed
abstract class RaiseControlState with _$RaiseControlState {
  const factory RaiseControlState({
    required bool canRaise,
    required bool raiseIsAllIn,
    required bool isFirstBet,
    required int maxPossibleBet,
    required int minPossibleBet,
    required int minRuleBet,
    required int currentBet,
  }) = _RaiseControlState;
}

@freezed
abstract class MainControlState with _$MainControlState {
  const factory MainControlState.check() = _MainControlCheckState;

  const factory MainControlState.call({
    required bool callIsAllIn,
    required int callValue,
  }) = _MainControlCallState;

  const MainControlState._();

  bool get canCheck => maybeMap(
        check: (value) => true,
        orElse: () => false,
      );
}
