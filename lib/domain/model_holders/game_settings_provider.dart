import '../models/game/game_settings_model.dart';

abstract interface class GameSettingsProvider {
  GameSettingsModelArgs get getSettings;

  Future<void> saveSettings(GameSettingsModelResult settings);
}
