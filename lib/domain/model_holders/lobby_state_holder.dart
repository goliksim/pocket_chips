import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/repositories.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/logs.dart';
import '../models/game/game_state_enum.dart';
import '../models/game_settings_model.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_model.dart';
import 'game_settings_provider.dart';

class LobbyStateHolder extends AsyncNotifier<LobbyStateModel>
    implements GameSettingsProvider {
  AppLocalizations get _strings => ref.read(stringsProvider);

  LobbyStateModel get activeLobby => state.requireValue;

  @override
  FutureOr<LobbyStateModel> build() async {
    logs.writeLog('LobbySH: READ DATA AND BUILD STATE');
    final lobby = await ref.read(appRepositoryProvider).getLobbyState();

    return lobby ?? LobbyStateModel.empty();
  }

  Future<void> updateLobby(LobbyStateModel newState) async {
    state = AsyncValue.data(newState);
    logs.writeLog('LobbySH: STATE UPDATED');

    try {
      await ref.read(appRepositoryProvider).updateLobbyState(newState);
    } catch (e) {
      logs.writeLog('Ошибка при сохранении лобби: $e');
    }
  }

  Future<void> createNewLobby() async {
    logs.writeLog('LobbySH: create new lobby');
    state = AsyncValue.data(
      LobbyStateModel.empty(),
    );
  }

  Future<void> updateDefaultBank(int newBank) {
    final lobby = activeLobby;

    final newBanks = Map.of(lobby.banks)
      ..updateAll(
        (_, __) => newBank,
      );

    logs.writeLog('LobbySH: default stack chenged to $newBank');

    return updateLobby(
      lobby.copyWith(
        defaultBank: newBank,
        banks: newBanks,
      ),
    );
  }

  Future<void> resetLobby() async {
    final lobby = activeLobby;

    final newBanks = Map.of(lobby.banks)
      ..updateAll(
        (_, __) => lobby.defaultBank,
      );

    logs.writeLog('LobbySH: reset with:\n lobbyBank: ${lobby.defaultBank}}');

    await updateLobby(
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

    // Проверка на статус лобби
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    // Проверка на дубли
    final samePlayer = currentLobby.players.firstWhereOrNull(
        (p) => (p.name == player.name) && (p.assetUrl == player.assetUrl));
    if (currentLobby.players.contains(player) || samePlayer != null) {
      throw Exception('${player.name} ${_strings.toast_alred}');
    }

    // Проверка на максимальное количество
    if (currentLobby.players.length >= maxPlayerCount) {
      throw Exception(_strings.toast_maxpl);
    }

    final newPlayers = [...currentLobby.players, player];

    final newBanks = Map<String, int>.from(currentLobby.banks)
      ..[player.uid] = bank;

    final newDealerId =
        makeDealer ? player.uid : currentLobby.dealerId ?? newPlayers.first.uid;

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    logs.writeLog('LobbySH: player ${player.name} added');
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

    logs.writeLog('LobbySH: player ${player.name} updated');
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
      newDealerId = newPlayers.isNotEmpty
          ? newPlayers[removedIndex % newPlayers.length].uid
          : null;
    }

    // Не изменяем currentPlayerId, так как удаление возможно только в перерывах,
    // когда currentPlayerId == null

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    logs.writeLog('LobbySH: player $playerUid removed');
    await updateLobby(newLobby);
  }

  Future<void> reorderPlayer(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

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

    logs.writeLog('LobbySH: players reordered');
    await updateLobby(newLobby);
  }

  @override
  GameSettingsModelArgs get getSettings {
    final lobby = activeLobby;

    return GameSettingsModelArgs(
      startingStack: lobby.defaultBank,
      canEditStack: lobby.gameState.isNotStarted,
      smallBlind: lobby.smallBlindValue,
    );
  }

  @override
  Future<void> saveSettings(GameSettingsModelResult settings) => updateLobby(
        activeLobby.copyWith(
          defaultBank: settings.startingStack ?? activeLobby.defaultBank,
          smallBlindValue: settings.smallBlind ?? activeLobby.smallBlindValue,
          banks: (settings.startingStack != null)
              ? (Map.of(activeLobby.banks)
                ..updateAll((_, __) => settings.startingStack!))
              : activeLobby.banks,
        ),
      );
}
