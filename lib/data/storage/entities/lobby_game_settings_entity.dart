import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/game/sit_out_mode.dart';
import 'blind_progression_entity.dart';

part 'lobby_game_settings_entity.g.dart';

@JsonSerializable()
class LobbyGameSettingsEntity {
  @JsonKey(defaultValue: false)
  final bool allowCustomBets;
  @JsonKey(defaultValue: SitOutMode.cashGame)
  final SitOutMode sitOutMode;
  final BlindProgressionEntity progression;

  const LobbyGameSettingsEntity({
    required this.allowCustomBets,
    required this.sitOutMode,
    required this.progression,
  });

  factory LobbyGameSettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$LobbyGameSettingsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyGameSettingsEntityToJson(this);
}
