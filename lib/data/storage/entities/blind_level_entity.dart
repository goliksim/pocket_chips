import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/game/blind_level_model.dart';

part 'blind_level_entity.g.dart';

@JsonSerializable()
class BlindLevelEntity {
  final int smallBlind;
  final AnteType anteType;
  final int anteValue;

  const BlindLevelEntity({
    required this.smallBlind,
    required this.anteType,
    required this.anteValue,
  });

  factory BlindLevelEntity.fromJson(Map<String, dynamic> json) =>
      _$BlindLevelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BlindLevelEntityToJson(this);
}
