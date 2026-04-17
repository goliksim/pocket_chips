import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state_effect.freezed.dart';

@freezed
abstract class GameStateEffect with _$GameStateEffect {
  const factory GameStateEffect.error({
    required GameStateErrorType type,
  }) = GameStateErrorEffect;

  const factory GameStateEffect.hasWinner({
    required String winnerUid,
  }) = GameStateHasWinnerEffect;

  const factory GameStateEffect.needWinnerSelection({
    required bool isSideSpot,
    @Default(0) int potValue,
    @Default(0) int anteValue,
    @Default(0) int foldedValue,
    @Default(<String, int>{}) Map<String, int> playerContributions,
  }) = GameStateNeedWinnerSelectionEffect;
}

enum GameStateErrorType {
  fewPlayers;
}
