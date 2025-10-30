import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/logs.dart';
import '../models/game/game_state_enum.dart';
import '../models/game_settings_model.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_model.dart';
import '../repositories/app_repository.dart';
import 'game_settings_provider.dart';

class LobbyStateHolder extends AsyncNotifier<LobbyStateModel?>
    implements GameSettingsProvider {
  final AppRepository _repository;
  final AppLocalizations _strings;

  LobbyStateHolder({
    required AppRepository repository,
    required AppLocalizations strings,
  })  : _repository = repository,
        _strings = strings;

  @override
  FutureOr<LobbyStateModel?> build() => _repository.getLobbyState();

  LobbyStateModel? get dataOrNull => state.value;

  LobbyStateModel get activeLobby {
    final state = dataOrNull;

    if (state == null) {
      throw (Exception('Call activeLobby without real lobby'));
    }

    return state;
  }

  Future<void> updateLobby(LobbyStateModel newState) async {
    state = AsyncValue.data(newState);

    try {
      await _repository.updateLobbyState(newState);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении лобби: $e');
    }
  }

  Future<void> createNewLobby() async => updateLobby(
        LobbyStateModel.empty(),
      );

  Future<void> updateDefaultBank(int newBank) {
    final lobby = activeLobby;

    final newBanks = Map.of(lobby.banks)
      ..updateAll(
        (_, __) => newBank,
      );

    logs.writeLog('Initial stack changed to:\t $newBank');

    return updateLobby(
      lobby.copyWith(
        defaultBank: newBank,
        banks: newBanks,
      ),
    );
  }

  Future<void> resetLobby() {
    final lobby = activeLobby;

    final newBanks = Map.of(lobby.banks)
      ..updateAll(
        (_, __) => lobby.defaultBank,
      );

    // TODO: _gameStateMachine.reset();

    logs.writeLog('Lobby reset with:\n lobbyBank: ${lobby.defaultBank}}');

    return updateLobby(
      lobby.copyWith(
        banks: newBanks,
        gameState: GameStatusEnum.notStarted,
      ),
    );
  }

  Future<void> addPlayer({
    required PlayerModel player,
    required bool makeDealer,
    int bank = defaultLobbyBank,
  }) async {
    final currentLobby = activeLobby;

    // Проверка на дубли
    if (currentLobby.players.contains(player)) {
      throw Exception('${player.name} ${_strings.toast_alred}');
    }

    // Проверка на максимальное количество
    if (currentLobby.players.length < maxPlayerCount) {
      throw Exception(_strings.toast_maxpl);
    }

    // Проверка на статус лобби
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    final newPlayers = [...currentLobby.players, player];

    final newBanks = Map<String, int>.from(currentLobby.banks)
      ..[player.uid] = bank;

    final newDealerId = makeDealer ? player.uid : currentLobby.dealerId;

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    await updateLobby(newLobby);
  }

  Future<void> updatePlayer({
    required PlayerModel player,
    required int bank,
    required bool makeDealer,
  }) async {
    final currentLobby = activeLobby;

    // Проверка на статус лобби
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    // Replace player entry in players list
    final newPlayers = currentLobby.players
        .map((p) => p.uid == player.uid ? player : p)
        .toList();

    final newBanks = Map<String, int>.from(currentLobby.banks)
      ..[player.uid] = bank;

    String? newDealerId = currentLobby.dealerId;
    if (makeDealer) {
      newDealerId = player.uid;
    } else if (newDealerId == player.uid) {
      // Make first player the dealer
      newDealerId = newPlayers.first.uid;
    }

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    await updateLobby(newLobby);
  }

  Future<void> removePlayer({required String playerUid}) async {
    final currentLobby = activeLobby;

    // Проверка на существование
    if (!currentLobby.players.any((p) => p.uid == playerUid)) {
      return;
    }

    // Проверка на статус лобби
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    final newPlayers =
        currentLobby.players.where((p) => p.uid != playerUid).toList();

    final newBanks = Map<String, int>.from(currentLobby.banks)
      ..remove(playerUid);

    final removedIndex =
        currentLobby.players.indexWhere((p) => p.uid == playerUid);

    String? newDealerId = currentLobby.dealerId;
    if (newDealerId == playerUid) {
      final nextIndex = removedIndex % newPlayers.length;
      newDealerId = newPlayers.isNotEmpty ? newPlayers[nextIndex].uid : null;
    }

    // Не изменяем currentPlayerId, так как удаление возможно только в перерывах,
    // когда currentPlayerId == null

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    await updateLobby(newLobby);
  }

  Future<void> reorderPlayer(int oldIndex, int newIndex) async {
    final currentLobby = activeLobby;

    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    final player = currentLobby.players[oldIndex];
    final newPlayers = List<PlayerModel>.from(currentLobby.players)
      ..removeAt(oldIndex)
      ..insert(newIndex, player);

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
    );

    await updateLobby(newLobby);
  }

  @override
  GameSettingsModel get getSettings {
    final lobby = activeLobby;

    return GameSettingsModel(
      startingStack: lobby.defaultBank,
      canEditStack: lobby.gameState.isNotStarted,
      smallBlind: lobby.smallBlindValue,
    );
  }

  @override
  Future<void> saveSettings(GameSettingsModel settings) => updateLobby(
        activeLobby.copyWith(
            defaultBank: settings.startingStack,
            smallBlindValue: settings.smallBlind),
      );
}
