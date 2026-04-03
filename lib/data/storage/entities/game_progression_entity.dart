import 'package:json_annotation/json_annotation.dart';

part 'game_progression_entity.g.dart';

@JsonSerializable()
class GameProgressionEntity {
  @JsonKey(defaultValue: 0)
  final int currentLevelIndex;
  final int? handsUntilNextLevel;
  final int? nextLevelAtEpochMsUtc;

  const GameProgressionEntity({
    this.currentLevelIndex = 0,
    this.handsUntilNextLevel,
    this.nextLevelAtEpochMsUtc,
  });

  factory GameProgressionEntity.fromJson(Map<String, dynamic> json) =>
      _$GameProgressionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameProgressionEntityToJson(this);
}
