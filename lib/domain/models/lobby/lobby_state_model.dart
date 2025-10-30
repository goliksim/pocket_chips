import 'package:freezed_annotation/freezed_annotation.dart';

import '../game/game_state_enum.dart';
import '../player/player_model.dart';

part 'lobby_state_model.freezed.dart';

const int defaultSmallBlindValue = 25;
const int defaultLobbyBank = 5000;

int maxPlayerCount = 10;

@freezed
abstract class LobbyStateModel with _$LobbyStateModel {
  const factory LobbyStateModel({
    required List<PlayerModel> players,
    required Map<String, int> banks,
    @Default(defaultSmallBlindValue) int smallBlindValue,
    @Default(GameStatusEnum.notStarted) GameStatusEnum gameState,
    @Default(defaultLobbyBank) int defaultBank,
    String? dealerId,
  }) = _LobbyStateModel;

  factory LobbyStateModel.empty() => const LobbyStateModel(
        players: [],
        banks: {},
      );
}

extension LobbyStateModelX on LobbyStateModel {
  int get bigBlindValue => smallBlindValue * 2;
}
