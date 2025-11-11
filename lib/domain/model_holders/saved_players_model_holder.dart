import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/repositories.dart';
import '../../utils/logs.dart';
import '../models/player/player_model.dart';

typedef SavedPlayers = List<PlayerModel>;

class SavedPlayersModelHolder extends AsyncNotifier<SavedPlayers> {
  @override
  FutureOr<SavedPlayers> build() =>
      ref.read(appRepositoryProvider).getSavedPlayers();

  Future<void> addPlayer(PlayerModel newPlayer) async {
    await future;

    try {
      if (state.requireValue.contains(newPlayer)) {
        throw Exception('Already Saved');
      }

      await ref.read(appRepositoryProvider).addPlayer(newPlayer);

      runBuild();
    } catch (e) {
      logs.writeLog('Ошибка при сохранении игрока: $e');

      rethrow;
    }
  }

  Future<void> updatePlayer({required PlayerModel player}) async {
    try {
      await ref.read(appRepositoryProvider).updatePlayer(player);

      runBuild();
    } catch (e) {
      logs.writeLog('Ошибка при обновлении данных игрока: $e');
    }
  }

  Future<void> removePlayer(String playerUid) async {
    try {
      await ref.read(appRepositoryProvider).removePlayer(playerUid);

      runBuild();
    } catch (e) {
      logs.writeLog('Ошибка при удалении игрока: $e');
    }
  }
}
