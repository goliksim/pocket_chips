import 'package:flutter/semantics.dart';

import '../../../domain/model_holders/lobby_state_holder.dart';

class BankEditorViewModel {
  final LobbyStateHolder _lobbyStateHolder;
  final VoidCallback _pop;

  late int currentDefaultBank;

  BankEditorViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required VoidCallback pop,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _pop = pop {
    _init();
  }

  void _init() {
    currentDefaultBank = _lobbyStateHolder.activeLobby.defaultBank;
  }

  Future<void> changeBank(int newBank) async {
    await _lobbyStateHolder.updateDefaultBank(newBank);

    _pop();
  }
}
