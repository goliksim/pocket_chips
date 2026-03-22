import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/game/game_state_model.dart';

class GamePreviousStateNotifier extends Notifier<StatePair> {
  @override
  StatePair build() => _nullPair;

  void setState(StatePair pair) {
    state = pair;
  }

  void clearPrevious() {
    state = _nullPair;
  }

  StatePair get _nullPair => (
        previous: null,
        current: null,
      );
}

typedef StatePair = ({GameStateModel? previous, GameStateModel? current});
