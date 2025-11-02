import 'package:flutter/semantics.dart';

import '../../../domain/model_holders/lobby_state_holder.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';

class BankEditorViewModel {
  final LobbyStateHolder _lobbyStateHolder;
  final ToastManager _toastManager;
  final AppLocalizations _strings;
  final VoidCallback _pop;

  final int currentDefaultBank;
  final int currentBigBlind;

  BankEditorViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required VoidCallback pop,
    required ToastManager toastManager,
    required AppLocalizations strings,
    required this.currentDefaultBank,
    required this.currentBigBlind,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _toastManager = toastManager,
        _strings = strings,
        _pop = pop;

  Future<void> changeBank(int newBank) async {
    if (newBank <= 0) {
      return;
    }

    if (newBank == currentDefaultBank) {
      return _pop();
    }

    await _lobbyStateHolder.updateDefaultBank(newBank);

    if (newBank < currentBigBlind) {
      _toastManager.showToast(_strings.toast_bank1);
    }

    _pop();
  }
}
