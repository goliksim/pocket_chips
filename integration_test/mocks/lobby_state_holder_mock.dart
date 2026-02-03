import 'dart:async';

import 'package:pocket_chips/domain/model_holders/lobby_state_holder.dart';
import 'package:pocket_chips/domain/models/lobby/lobby_state_model.dart';

class MockLobbyStateHolder extends LobbyStateHolder {
  LobbyStateModel? _initialState;

  MockLobbyStateHolder({
    LobbyStateModel? initialState,
  }) {
    _initialState = initialState;
  }

  @override
  FutureOr<LobbyStateModel> build() async =>
      _initialState ?? LobbyStateModel.empty();

  @override
  Future<void> createNewLobby() async {}
}
