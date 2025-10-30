import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_session_entity.g.dart';

@JsonSerializable()
class GameSessionEntity {
  final Map<String, int> bets;
  final Set<String> foldedOrInactive;
  final int lapCounter;
  final String? currentPlayerUid;

  const GameSessionEntity({
    required this.bets,
    required this.foldedOrInactive,
    required this.lapCounter,
    this.currentPlayerUid,
  });

  factory GameSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$GameSessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameSessionEntityToJson(this);
}
