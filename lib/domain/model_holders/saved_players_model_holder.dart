import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/logs.dart';
import '../models/player/player_model.dart';
import '../repositories/app_repository.dart';

typedef SavedPlayers = List<PlayerModel>;

class SavedPlayersModelHolder extends AsyncNotifier<SavedPlayers> {
  final AppRepository _repository;

  SavedPlayersModelHolder({required AppRepository repository})
      : _repository = repository;

  @override
  FutureOr<SavedPlayers> build() => _build();

  Future<SavedPlayers> _build() => _repository.getSavedPlayers();

  SavedPlayers get players => state.value ?? <PlayerModel>[];

  Future<void> addPlayer(PlayerModel newPlayer) async {
    try {
      if (players.contains(newPlayer)) {
        throw Exception('Игрок уже был добавлен ранне');
      }

      await _repository.addPlayer(newPlayer);

      runBuild();
    } catch (e) {
      logs.writeLog('Ошибка при сохранении игрока: $e');
    }
  }

  Future<void> removePlayer(String playerUid) async {
    try {
      await _repository.removePlayer(playerUid);

      runBuild();
    } catch (e) {
      logs.writeLog('Ошибка при удалении игрока: $e');
    }
  }
}
