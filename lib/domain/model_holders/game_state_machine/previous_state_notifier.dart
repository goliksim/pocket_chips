import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game/game_state_model.dart';

class GamePreviousStateNotifier extends Notifier<List<GameStateModel>> {
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
          candidate.lobbyState.gameState != currentState.lobbyState.gameState ||
          candidate.sessionState != currentState.sessionState) {
        nextValid = candidate;
        break;
      }
    }

    state = newState;
    return nextValid;
  }

  void clearPrevious() {
    state = [];
  }
}
