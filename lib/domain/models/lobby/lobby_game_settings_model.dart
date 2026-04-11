import 'package:freezed_annotation/freezed_annotation.dart';

import '../game/blind_progression_model.dart';

part 'lobby_game_settings_model.freezed.dart';

@freezed
abstract class LobbyGameSettingsModel with _$LobbyGameSettingsModel {
  const factory LobbyGameSettingsModel({
    required BlindProgressionModel progression,
    @Default(false) bool allowCustomBets,
  }) = _LobbyGameSettingsModel;

  static const LobbyGameSettingsModel defaultModel = LobbyGameSettingsModel(
    progression: BlindProgressionModel.defaultModel,
  );
}
