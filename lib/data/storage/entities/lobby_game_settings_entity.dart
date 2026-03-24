import 'package:json_annotation/json_annotation.dart';

import 'blind_progression_entity.dart';

part 'lobby_game_settings_entity.g.dart';

@JsonSerializable()
class LobbyGameSettingsEntity {
  @JsonKey(defaultValue: false)
  final bool allowCustomBets;
  final BlindProgressionEntity progression;

  const LobbyGameSettingsEntity({
    required this.allowCustomBets,
    required this.progression,
  });

  factory LobbyGameSettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$LobbyGameSettingsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyGameSettingsEntityToJson(this);
}
