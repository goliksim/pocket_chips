import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/model_holders.dart';
import '../../../utils/logs.dart';

class GameTableOffsetController extends Notifier<int> {
  @override
  int build() {
    final model = ref.read(gameStateMachineProvider).requireValue;

    final int dealerIndex = model.lobbyState.players
        .indexWhere((p) => p.uid == model.lobbyState.dealerId);

    return model.lobbyState.players.length ~/ 2 - dealerIndex;
  }

  void increaseOffset() {
    logs.writeLog('GameVM: player rotation');
    state += 1;
  }

  // Меняем отступы у игроков
  /*
  void changeOffset() {
    Random rnd = Random();

    List<double> arr = [];
    for (int p = 0; p < maxPlayerCount; p++) {
      arr.add((rnd.nextInt(40) - 20) / 360 * 2 * pi);
    }
    arr[0] = 0.0;

    state = AsyncData(
      viewState.copyWith(
        tableState: viewState.tableState.copyWith(
          tablePlayersOffsets: arr,
        ),
      ),
    );
  }*/
}
