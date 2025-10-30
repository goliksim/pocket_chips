import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/game/game_state_enum.dart';
import 'game_table_state.dart';

part 'game_page_view_state.freezed.dart';

@freezed
abstract class GamePageViewState with _$GamePageViewState {
  const factory GamePageViewState({
    required GameStatusEnum gameStatus,
    required GameTableState tableState,
    required String currentGameState,
    required bool canEditPlayer,
    String? currentPlayerName,
  }) = _GamePageViewState;
}
