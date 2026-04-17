import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/domain_managers.dart';
import '../../di/model_holders.dart';
import '../../di/repositories.dart';
import '../../l10n/app_localizations.dart';
import '../../services/crash_reporting_service.dart';
import '../../services/toast_manager.dart';
import '../../utils/logs.dart';
import '../models/game/game_session_state.dart';
import '../models/game/game_settings_model.dart';
import '../models/game/game_state_enum.dart';
import '../models/lobby/lobby_game_settings_model.dart';
import '../models/lobby/lobby_state_model.dart';
import '../models/player/player_model.dart';
import '../repositories/app_repository.dart';
import 'game_settings_provider.dart';

class LobbyStateHolder extends AsyncNotifier<LobbyStateModel>
    implements GameSettingsProvider {
  AppLocalizations get _strings => ref.read(stringsProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppRepository get _appRepository => ref.read(appRepositoryProvider);
  CrashReportingService get _crashReporting =>
      ref.read(crashReportingServiceProvider);

  LobbyStateModel get activeLobby => state.requireValue;

  @override
  FutureOr<LobbyStateModel> build() async {
    logs.writeLog('LobbySH: READ DATA AND BUILD STATE');
    final lobby = await _appRepository.getLobbyState();

    return lobby ?? LobbyStateModel.empty();
  }

  Future<void> updateLobby(LobbyStateModel newState) async {
    state = AsyncData(newState);
    logs.writeLog('LobbySH: STATE UPDATED');

    try {
      await _appRepository.updateLobbyState(newState);
    } catch (error, trace) {
      logs.writeLog('LobbySH: save lobby state error - $error');

      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'LobbyStateHolder.updateLobby',
        ),
      );
    }
  }

  Future<void> createNewLobby() async {
    logs.writeLog('LobbySH: create new lobby');

    await updateLobby(LobbyStateModel.empty());
    await _appRepository.updateGameSessionState(GameSessionState.initial());
    ref.read(gamePreviousStateNotifierProvider.notifier).clearPrevious();
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

    final newLobbyState = lobby.copyWith(
      banks: newBanks,
      gameState: GameStatusEnum.notStarted,
    );

    try {
      await updateLobby(newLobbyState);
      await _appRepository.updateGameSessionState(GameSessionState.initial());
    } catch (error, trace) {
      logs.writeLog('LobbySH: reset lobby error - $error');

      unawaited(
        _crashReporting.recordError(
          error: error,
          trace: trace,
          reason: 'LobbyStateHolder.resetLobby',
        ),
      );
    }
  }

  Future<void> addPlayer({
    required PlayerModel player,
    required bool makeDealer,
    int? bank,
  }) async {
    final currentLobby = activeLobby;

    // Lobby status check
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    // Checking for duplicates
    final samePlayer =
        currentLobby.players.firstWhereOrNull((p) => (p.name == player.name));
    if (currentLobby.players.contains(player) || samePlayer != null) {
      throw Exception('${player.name} ${_strings.toast_alred}');
    }

    // Checking for max limits
    if (currentLobby.players.length >= maxPlayerCount) {
      throw Exception(_strings.toast_maxpl);
    }

    final newPlayers = [...currentLobby.players, player];

    final newBanks = Map<String, int>.from(currentLobby.banks)
      ..[player.uid] = bank ?? currentLobby.defaultBank;

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
    required bool makeDealer,
    int? bank,
  }) async {
    final currentLobby = activeLobby;

    // Lobby status check
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    // Checking for duplicates
    final samePlayer = currentLobby.players.firstWhereOrNull(
        (p) => (p.name == player.name) && (p.uid != player.uid));
    if (samePlayer != null) {
      throw Exception('${player.name} ${_strings.toast_alred}');
    }

    // Replace player entry in players list
    final newPlayers = currentLobby.players
        .map((p) => p.uid == player.uid ? player : p)
        .toList();

    final newBanks = (bank != null)
        ? (Map<String, int>.from(currentLobby.banks)..[player.uid] = bank)
        : currentLobby.banks;

    String? newDealerId = currentLobby.dealerId;
    if (makeDealer) {
      newDealerId = player.uid;
    } else if (newDealerId == player.uid) {
      // Make first player the dealer
      newDealerId = newPlayers.first.uid;
      _toastManager.showToast(
        '${_strings.toast_playp_edit_new_dealer} ${newPlayers.first.name}',
      );
    }

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    logs.writeLog('LobbySH: player ${player.name} updated');
    await updateLobby(newLobby);
  }

  Future<void> removePlayer(String playerUid) async {
    final currentLobby = activeLobby;

    // Lobby status check
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    // Check for existace
    if (!currentLobby.players.any((p) => p.uid == playerUid)) {
      throw Exception('Player $playerUid not found');
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

    // We dont need to change currentPlayerId, because it can be changed only in pause state
    // In these cases currentPlayerId is already null

    final newLobby = currentLobby.copyWith(
      players: newPlayers,
      banks: newBanks,
      dealerId: newDealerId,
    );

    logs.writeLog('LobbySH: player $playerUid removed');
    await updateLobby(newLobby);
  }

  Future<void> reorderPlayer(int oldIndex, int newIndex) async {
    final currentLobby = activeLobby;
    if (!currentLobby.gameState.canEditPlayers) {
      throw Exception('Cannot edit player list on this state');
    }

    final newPlayers = List<PlayerModel>.from(currentLobby.players);
    newPlayers.reorder(oldIndex, newIndex);

    logs.writeLog('LobbySH: players reordered');
    await updateLobby(currentLobby.copyWith(
      players: newPlayers,
    ));
  }

  @override
  GameSettingsModelArgs get getSettings {
    final lobby = activeLobby;

    return GameSettingsModelArgs(
      startingStack: lobby.defaultBank,
      allowCustomBets: lobby.settings.allowCustomBets,
      progression: lobby.settings.progression,
      sitOutMode: lobby.settings.sitOutMode,
    );
  }

  @override
  Future<void> saveSettings(GameSettingsModelResult settings) => updateLobby(
        activeLobby.copyWith(
          defaultBank: settings.newStartingStack ?? activeLobby.defaultBank,
          settings: LobbyGameSettingsModel(
            allowCustomBets: settings.allowCustomBets ??
                activeLobby.settings.allowCustomBets,
            progression: settings.newProgression,
            sitOutMode: settings.sitOutMode ?? activeLobby.settings.sitOutMode,
          ),
          banks: (settings.newStartingStack != null)
              ? (Map.of(activeLobby.banks)
                ..updateAll((_, __) => settings.newStartingStack!))
              : activeLobby.banks,
        ),
      );
}

extension ReorderList<T> on List<T> {
  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = removeAt(oldIndex);
    insert(newIndex, item);
  }
}
