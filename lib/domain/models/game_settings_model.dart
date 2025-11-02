import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_settings_model.freezed.dart';

@freezed
abstract class GameSettingsModel with _$GameSettingsModel {
  const factory GameSettingsModel({
    required int startingStack,
    required bool canEditStack,
    required int smallBlind,
    // TODO: add ante
  }) = GameSettingsModelArgs;

  const factory GameSettingsModel.result({
    required int? startingStack,
    required int? smallBlind,
    // TODO: add ante
  }) = GameSettingsModelResult;
}
