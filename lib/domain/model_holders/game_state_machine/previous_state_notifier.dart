import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/domain_managers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';
import '../../models/game/game_state_model.dart';
import '../../models/lobby/lobby_state_model.dart';

class GamePreviousStateNotifier extends Notifier<List<GameStateModel>> {
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  static const int _maxStackSize = 20;

  @override
  List<GameStateModel> build() => [];

  bool get hasPrevious => state.isNotEmpty;

  void pushState(GameStateModel stateToPush) {
    final cleanState = stateToPush.copyWith(effects: []);

    if (state.isEmpty || state.last != cleanState) {
      final newState = [...state, cleanState];
      if (newState.length > _maxStackSize) {
        newState.removeAt(0);
      }
      state = newState;
    }
  }

  GameStateModel? popNextValidState(GameStateModel? currentState) {
    if (state.isEmpty) return null;

    GameStateModel? nextValid;
    final newState = List<GameStateModel>.from(state);

    while (newState.isNotEmpty) {
      final candidate = newState.removeLast();
      if (currentState == null ||
          candidate.lobbyState != currentState.lobbyState ||
          candidate.sessionState != currentState.sessionState) {
        nextValid = candidate;
        break;
      }
    }
    state = newState;

    if (nextValid == null) {
      return null;
    }

    // Do not restore old defaultBank and player info
    final currentLobby = currentState?.lobbyState;
    final nextLobby = nextValid.lobbyState;

    final LobbyStateModel? correctLobby;
    correctLobby = nextLobby.copyWith(
      defaultBank: currentLobby?.defaultBank ?? nextLobby.defaultBank,
      players: nextLobby.players.map((p) {
        final newPlayerInfo =
            currentLobby?.players.firstWhereOrNull((pp) => pp.uid == p.uid);

        return newPlayerInfo ?? p;
      }).toList(),
    );

    if (currentLobby?.settings != correctLobby.settings) {
      _toastManager.showToast(_strings.toast_settings_undo);
    }

    return nextValid.copyWith(
      lobbyState: correctLobby,
    );
  }

  void clearPrevious() {
    state = [];
  }
}
