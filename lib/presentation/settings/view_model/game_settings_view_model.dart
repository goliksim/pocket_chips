import 'package:flutter/material.dart';

import '../../../domain/model_holders/game_settings_provider.dart';
import '../../../domain/models/game_settings_model.dart';
import '../../../utils/logs.dart';

class GameSettingsViewModel {
  final GameSettingsProvider _gameSettingsProvider;
  final VoidCallback _pop;

  late GameSettingsModel state;

  GameSettingsViewModel({
    required GameSettingsProvider gameSettingsProvider,
    required VoidCallback pop,
  })  : _gameSettingsProvider = gameSettingsProvider,
        _pop = pop {
    _init();
  }

  void _init() {
    state = _gameSettingsProvider.getSettings;
  }

  Future<void> saveSettings(GameSettingsModel settings) async {
    await _gameSettingsProvider.saveSettings(settings);

    logs.writeLog('Close settings with $settings');

    _pop();
  }
}
