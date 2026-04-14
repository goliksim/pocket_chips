import 'package:json_annotation/json_annotation.dart';

part 'game_progression_entity.g.dart';

@JsonSerializable()
class GameProgressionEntity {
  @JsonKey(defaultValue: 0)
  final int currentLevelIndex;
  final int? handsFromLevelStart;
  final int? levelTimerStartMsUtc;

  const GameProgressionEntity({
    this.currentLevelIndex = 0,
    this.handsFromLevelStart,
    this.levelTimerStartMsUtc,
  });

  factory GameProgressionEntity.fromJson(Map<String, dynamic> json) =>
      _$GameProgressionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GameProgressionEntityToJson(this);
}
