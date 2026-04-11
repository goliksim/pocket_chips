import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/game/blind_level_model.dart';
import 'game_player_item.dart';

part 'game_table_state.freezed.dart';

@freezed
abstract class GameTableState with _$GameTableState {
  const factory GameTableState({
    required List<GamePlayerItem> players,
    required int smallBlindValue,
    required BlindProgressionType progressionType,
    required AnteType anteType,
    required bool showProgression,
    int? anteValue,
    int? progressionLevel,
    int? leftInterval,
  }) = _GameTableState;
}
