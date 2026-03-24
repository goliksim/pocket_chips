import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/game/game_state_enum.dart';
import 'player_entity.dart';

part 'lobby_state_entity.g.dart';

@JsonSerializable()
class LobbyStateEntity {
  final GameStatusEnum gameState;
  final int smallBlindValue;
  final int defaultBank;
  @JsonKey(defaultValue: false)
  final bool allowCustomBets;

  final List<PlayerEntity>? players;
  final Map<String, int>? banks;
  final String? dealerId;

  const LobbyStateEntity({
    required this.smallBlindValue,
    required this.defaultBank,
    required this.gameState,
    required this.allowCustomBets,
    this.players,
    this.banks,
    this.dealerId,
  });

  factory LobbyStateEntity.fromJson(Map<String, dynamic> json) =>
      _$LobbyStateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyStateEntityToJson(this);

  @override
  String toString() =>
      '[LobbyStateEntity] - players: $players, banks: $banks, smallBlindValue: $smallBlindValue, dealerId: $dealerId, defaultBank: $defaultBank, allowCustomBets: $allowCustomBets, gameState: $gameState';
}
