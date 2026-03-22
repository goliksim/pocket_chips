import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/game/game_state_enum.dart';
import 'player_entity.dart';

part 'lobby_state_entity.g.dart';

@JsonSerializable()
class LobbyStateEntity {
  final GameStatusEnum gameState;
  final int smallBlindValue;
  final int defaultBank;

  final List<PlayerEntity>? players;
  final Map<String, int>? banks;
  final String? dealerId;

  const LobbyStateEntity({
    required this.smallBlindValue,
    required this.defaultBank,
    required this.gameState,
    this.players,
    this.banks,
    this.dealerId,
  });

  factory LobbyStateEntity.fromJson(Map<String, dynamic> json) =>
      _$LobbyStateEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyStateEntityToJson(this);

  @override
  String toString() =>
      '[LobbyStateEntity] - players: $players, banks: $banks, smallBlindValue: $smallBlindValue, dealerId: $dealerId, defaultBank: $defaultBank, gameState: $gameState';
}
