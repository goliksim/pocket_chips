import '../models/game_settings_model.dart';

abstract interface class GameSettingsProvider {
  GameSettingsModel get getSettings;

  Future<void> saveSettings(GameSettingsModel settings);
}
