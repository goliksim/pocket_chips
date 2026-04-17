import 'package:freezed_annotation/freezed_annotation.dart';

import 'blind_progression_model.dart';
import 'sit_out_mode.dart';

part 'game_settings_model.freezed.dart';

@freezed
abstract class GameSettingsModel with _$GameSettingsModel {
  const factory GameSettingsModel({
    required int startingStack,
    required BlindProgressionModel progression,
    @Default(false) bool allowCustomBets,
    @Default(SitOutMode.cashGame) SitOutMode sitOutMode,
  }) = GameSettingsModelArgs;

  const factory GameSettingsModel.result({
    required BlindProgressionModel newProgression,
    bool? allowCustomBets,
    SitOutMode? sitOutMode,
    int? newStartingStack,
  }) = GameSettingsModelResult;
}
