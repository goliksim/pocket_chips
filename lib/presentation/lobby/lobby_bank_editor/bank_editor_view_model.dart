import 'package:flutter/foundation.dart';

import '../../../domain/model_holders/lobby_state_holder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';

class BankEditorViewModel {
  final LobbyStateHolder _lobbyStateHolder;
  final ToastManager _toastManager;
  final AppLocalizations _strings;
  final VoidCallback _pop;

  final int currentDefaultBank;
  final int minRecommendedStartingStack;

  BankEditorViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required VoidCallback pop,
    required ToastManager toastManager,
    required AppLocalizations strings,
    required this.currentDefaultBank,
    required this.minRecommendedStartingStack,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _toastManager = toastManager,
        _strings = strings,
        _pop = pop;

  Future<void> changeBank(int newBank) async {
    if (!kDebugMode && newBank <= 0) {
      return _toastManager.showToast(_strings.toast_bank3);
    }

    await _lobbyStateHolder.updateDefaultBank(newBank);

    if (newBank < minRecommendedStartingStack) {
      _toastManager.showToast(_strings.toast_bank_warning);
    }

    _pop();
  }
}
