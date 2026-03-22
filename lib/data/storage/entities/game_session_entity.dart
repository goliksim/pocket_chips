import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_entity.g.dart';

@JsonSerializable()
class GameSessionEntity {
  final Map<String, int> bets;
  final Set<String> foldedPlayersInactive;
  final int lapCounter;
  final String? currentPlayerUid;
  final String? firstPlayerUid;

  const GameSessionEntity({
    required this.bets,
    required this.foldedPlayersInactive,
    required this.lapCounter,
    this.currentPlayerUid,
    this.firstPlayerUid,
  });

  factory GameSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$GameSessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameSessionEntityToJson(this);
}
