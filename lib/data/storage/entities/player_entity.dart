import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/models/player/player_id.dart';

part 'player_entity.g.dart';

@JsonSerializable()
class PlayerEntity {
  @JsonKey(fromJson: PlayerEntity.idFromJson)
  final PlayerId uid;

  final String name;
  final String assetUrl;

  PlayerEntity({
    required this.uid,
    required this.name,
    required this.assetUrl,
  });

  factory PlayerEntity.fromJson(Map<String, dynamic> json) =>
      _$PlayerEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerEntityToJson(this);

  // Generate new id for old versions
  static String idFromJson(String? uid) {
    return uid ?? Uuid().v4();
  }

  @override
  String toString() {
    return '[PlayerEntity] - id: $uid, name: $name, assetUrl: $assetUrl';
  }
}
