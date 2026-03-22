import 'package:flutter/material.dart';

import '../../../domain/model_holders/game_settings_provider.dart';
import '../../../domain/models/game_settings_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/logs.dart';

class GameSettingsViewModel {
  final GameSettingsProvider _gameSettingsProvider;
  final ToastManager _toastManager;
  final AppLocalizations _strings;
  final VoidCallback _pop;

  late GameSettingsModelArgs state;

  GameSettingsViewModel({
    required GameSettingsProvider gameSettingsProvider,
    required ToastManager toastManager,
    required AppLocalizations strings,
    required VoidCallback pop,
  })  : _gameSettingsProvider = gameSettingsProvider,
        _toastManager = toastManager,
        _strings = strings,
        _pop = pop {
    _init();
  }

  void _init() {
    state = _gameSettingsProvider.getSettings;
  }

  Future<void> saveSettings(GameSettingsModelResult settings) async {
    final resultStack = settings.startingStack ?? state.startingStack;
    final resultSmallBlind = settings.smallBlind ?? state.smallBlind;

    if (resultStack < resultSmallBlind * 2) {
      _toastManager.showToast(_strings.toast_bank1);
    }

    await _gameSettingsProvider.saveSettings(settings);

    logs.writeLog('Close settings with $settings');

    _pop();
  }
}
