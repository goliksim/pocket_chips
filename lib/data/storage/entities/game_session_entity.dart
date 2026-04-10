import 'package:freezed_annotation/freezed_annotation.dart';

import 'game_progression_entity.dart';

part 'game_session_entity.g.dart';

@JsonSerializable()
class GameSessionEntity {
  final Map<String, int> bets;
  @JsonKey(defaultValue: <String, int>{})
  final Map<String, int> anteBets;
  final Set<String> foldedPlayersInactive;
  final int lapCounter;
  final GameProgressionEntity? progressionState;
  final String? currentPlayerUid;
  final String? firstPlayerUid;

  const GameSessionEntity({
    required this.bets,
    required this.anteBets,
    required this.foldedPlayersInactive,
    required this.lapCounter,
    this.progressionState,
    this.currentPlayerUid,
    this.firstPlayerUid,
  });

  factory GameSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$GameSessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameSessionEntityToJson(this);
}
