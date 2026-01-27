import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state_effect.freezed.dart';

@freezed
abstract class GameStateEffect with _$GameStateEffect {
  const factory GameStateEffect.error({
    required GameStateErrorType type,
  }) = _GameStateErrorEffect;

  const factory GameStateEffect.hasWinner({
    required String winnerUid,
  }) = _GameStateHasWinnerEffect;

  const factory GameStateEffect.needWinnerSelection({
    required Set<String> possibleWinnersUid,
    required bool isSideSpot,
  }) = _GameStateNeedWinnerSelectionEffect;
}

enum GameStateErrorType {
  fewPlayers;
}
