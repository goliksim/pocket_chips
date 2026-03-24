import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/game/blind_level_model.dart';
import '../../../domain/models/game/blind_progression_model.dart';
import 'blind_level_entity.dart';

part 'blind_progression_entity.g.dart';

enum BlindProgressionMode {
  simple,
  pro;
}

@JsonSerializable()
class BlindProgressionEntity {
  final BlindProgressionMode mode;
  final BlindProgressionType progressionType;
  final int? progressionInterval;
  final List<BlindLevelEntity> levels;

  const BlindProgressionEntity({
    required this.mode,
    required this.progressionType,
    required this.levels,
    this.progressionInterval,
  });

  factory BlindProgressionEntity.fromJson(Map<String, dynamic> json) =>
      _$BlindProgressionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BlindProgressionEntityToJson(this);
}

extension BlindProgressionModelX on BlindProgressionModel {
  BlindProgressionMode get mode => map(
        (_) => BlindProgressionMode.simple,
        pro: (_) => BlindProgressionMode.pro,
      );
}
