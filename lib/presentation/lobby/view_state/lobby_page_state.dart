import 'package:freezed_annotation/freezed_annotation.dart';

import '../player_list/view_state/lobby_player_item.dart';

part 'lobby_page_state.freezed.dart';

@freezed
abstract class LobbyPageState with _$LobbyPageState {
  const factory LobbyPageState({
    required List<LobbyPlayerItem> players,
    required bool gameActive,
    required bool canEditPlayers,
    required bool canAddPlayer,
    required int startingStack,
  }) = _LobbyPageState;
}
