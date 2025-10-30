import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_player_item.dart';

part 'game_table_state.freezed.dart';

@freezed
abstract class GameTableState with _$GameTableState {
  const factory GameTableState({
    required List<GamePlayerItem> players,
    required int tableRotationOffset,
    required int smallBlindValue,
    List<double>? tablePlayersOffsets,
  }) = _GameTableState;
}
