import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../app/navigation/models/app_route.dart';
import '../../../app/navigation/navigation_manager.dart';
import '../../../domain/model_holders/lobby_state_holder.dart';
import '../../../domain/model_holders/saved_players_model_holder.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/lobby/lobby_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/logs.dart';
import '../player_list/view_state/lobby_player_item.dart';
import '../view_state/lobby_page_state.dart';

class LobbyPageViewModel with ChangeNotifier {
  final LobbyStateHolder _lobbyStateHolder;
  final SavedPlayersModelHolder _savedPlayersModelHolder;
  final NavigationManager _navigationManager;
  final ToastManager _toastManager;
  final AppLocalizations _strings;

  ScrollController scrollController = ScrollController();

  late LobbyPageState lobbyState;

  LobbyPageViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required NavigationManager navigationManager,
    required SavedPlayersModelHolder savedPlayersModelHolder,
    required ToastManager toastManager,
    required AppLocalizations strings,
    required Function(VoidCallback) addListener,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _navigationManager = navigationManager,
        _savedPlayersModelHolder = savedPlayersModelHolder,
        _strings = strings,
        _toastManager = toastManager {
    _init();

    addListener(_init);
  }

  void _init() {
    final lobby = _lobbyStateHolder.activeLobby;

    final canEditPlayers = lobby.gameState.canEditPlayers;

    lobbyState = LobbyPageState(
      gameActive: lobby.gameState.isStarted,
      canEditPlayers: canEditPlayers,
      canAddPlayer: canEditPlayers && lobby.players.length < maxPlayerCount,
      startingStack: lobby.defaultBank,
      players: lobby.players
          .map((p) => p.toStateItem(
                isDealer: p.uid == lobby.dealerId,
                bank: lobby.banks[p.uid],
              ))
          .toList(),
    );
  }

  void openSavedPlayersList() => _navigationManager.showSavedPlayers();

  void openNewPlayerEditor() => _navigationManager.showPlayerEditor(null);

  void openPlayerEditor(String playerUid) =>
      _navigationManager.showPlayerEditor(playerUid);

  void pop() => _navigationManager.pop();

  Future<bool> savePlayer(String playerUid) async {
    final playerModel =
        lobbyState.players.firstWhereOrNull((p) => p.uid == playerUid);

    if (playerModel == null) {
      return false;
    }

    try {
      await _savedPlayersModelHolder.addPlayer(playerModel.toDomain);

      _toastManager.showToast(
        '${playerModel.name} ${_strings.toast_saved}',
      );

      logs.writeLog('Saving:\t${playerModel.toString()}');
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());
    }

    return false;
  }

  Future<bool> removePlayer(String playerUid) async {
    final result = await _navigationManager.showConfirmationDialog(
      title: _strings.conf_del_tittle,
      actionTitle: _strings.conf_del_butt,
      message: _strings.conf_del_text,
      action: () => _removePlayer(playerUid),
    );

    return result ?? false;
  }

  Future<void> onPlayerTap(String playerUid) =>
      _navigationManager.showPlayerEditor(playerUid);

  //TODO не забыть о скроле вниз при добавлении нового игрока
  void addButtonPressed() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.ease,
      );
    }
  }

  Future<void> onReorderPlayer(int oldIndex, int newIndex) =>
      _lobbyStateHolder.reorderPlayer(oldIndex, newIndex);

  Future<void> openStartingStackEditor() =>
      _navigationManager.showStartingStackEditor();

  Future<void> resetLobby() => _navigationManager.showConfirmationDialog(
        title: _strings.conf_rest_tittle,
        actionTitle: _strings.conf_rest_butt,
        message: _strings.conf_rest_text,
        action: () async {
          _lobbyStateHolder.resetLobby();
        },
      );

  Future<void> onStartGame() async {
    final cannotStartGame = lobbyState.players.length < 2;

    if (cannotStartGame) {
      _toastManager.showToast(_strings.toast_moreplay2);
    } else {
      _navigationManager.goTo(
        AppRoute.game(),
      );
    }
  }

  Future<void> onSettingsTap() => _navigationManager.showLobbySettings();

  Future<void> _removePlayer(String playerUid) async {
    final playerModel =
        lobbyState.players.firstWhereOrNull((p) => p.uid == playerUid);

    if (playerModel == null) {
      return;
    }

    try {
      await _lobbyStateHolder.removePlayer(playerUid: playerUid);

      _toastManager.showToast(
        '${playerModel.name} ${_strings.toast_saved}',
      );

      logs.writeLog('Saving:\t${playerModel.toString()}');
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());
    }

    return;
  }
}
