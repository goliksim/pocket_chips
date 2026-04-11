import 'package:freezed_annotation/freezed_annotation.dart';

import 'blind_progression_model.dart';

part 'game_settings_model.freezed.dart';

@freezed
abstract class GameSettingsModel with _$GameSettingsModel {
  const factory GameSettingsModel({
    required int startingStack,
    required BlindProgressionModel progression,
    @Default(false) bool allowCustomBets,
  }) = GameSettingsModelArgs;

  const factory GameSettingsModel.result({
    required BlindProgressionModel newProgression,
    bool? allowCustomBets,
    int? newStartingStack,
  }) = GameSettingsModelResult;
}
