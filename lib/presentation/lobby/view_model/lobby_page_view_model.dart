import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/navigation/models/app_route.dart';
import '../../../app/navigation/navigation_manager.dart';
import '../../../di/domain_managers.dart';
import '../../../di/model_holders.dart';
import '../../../di/view_models.dart';
import '../../../domain/model_holders/lobby_state_holder.dart';
import '../../../domain/model_holders/saved_players_model_holder.dart';
import '../../../domain/models/game/game_state_enum.dart';
import '../../../domain/models/lobby/lobby_state_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/toast_manager.dart';
import '../../../utils/logs.dart';
import '../player_list/view_state/lobby_player_item.dart';
import '../view_state/lobby_page_state.dart';

class LobbyPageViewModel extends AsyncNotifier<LobbyPageState> {
  LobbyStateHolder get _lobbyStateHolder =>
      ref.read(lobbyStateHolderProvider.notifier);
  SavedPlayersModelHolder get _savedPlayersModelHolder =>
      ref.read(savedPlayersModelHolderProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  @override
  FutureOr<LobbyPageState> build() async {
    _listenPlayersChanges();

    final lobby = await ref.watch(lobbyStateHolderProvider.future);

    final canEditPlayers = lobby.gameState.canEditPlayers;

    return LobbyPageState(
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

  void openNewPlayerEditor() {
    if (state.requireValue.canEditPlayers) {
      _navigationManager.showPlayerEditor(null);
    } else {
      _toastManager.showToast(_strings.toast_game_error_state_editing);
    }
  }

  void openPlayerEditor(String playerUid) {
    if (state.requireValue.canEditPlayers) {
      _navigationManager.showPlayerEditor(playerUid);
    } else {
      _toastManager.showToast(_strings.toast_game_error_state_editing);
    }
  }

  void pop() => _navigationManager.pop();

  Future<bool> savePlayer(String playerUid) async {
    final isPro = ref.read(proVersionProvider);

    if (!isPro) {
      _navigationManager.showProVersionOfferDialog();

      return false;
    }

    final playerModel =
        state.requireValue.players.firstWhereOrNull((p) => p.uid == playerUid);

    if (playerModel == null) {
      return false;
    }

    try {
      await _savedPlayersModelHolder.addPlayer(playerModel.toDomain);

      _toastManager.showToast('${playerModel.name} ${_strings.toast_saved}');
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
      action: () {},
    );

    return (result ?? false) ? _removePlayer(playerUid) : Future.value(false);
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
    final cannotStartGame = state.requireValue.players.length < 2;

    if (cannotStartGame) {
      _toastManager.showToast(_strings.toast_moreplay2);
    } else {
      _navigationManager.goTo(
        AppRoute.game(),
      );
    }
  }

  Future<void> onSettingsTap() => _navigationManager.showLobbySettings();

  Future<bool> _removePlayer(String playerUid) async {
    final playerModel =
        state.requireValue.players.firstWhereOrNull((p) => p.uid == playerUid);

    if (playerModel == null) {
      return false;
    }

    try {
      await _lobbyStateHolder.removePlayer(playerUid);

      logs.writeLog('Saving:\t${playerModel.toString()}');
      return true;
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());

      return false;
    }
  }

  void _listenPlayersChanges() {
    ref.listen<AsyncValue<LobbyStateModel>>(
      lobbyStateHolderProvider,
      (previous, next) {
        next.whenData(
          (newLobby) {
            previous?.whenData(
              (oldLobby) {
                if (newLobby.players.length > oldLobby.players.length) {
                  Future.delayed(Duration(milliseconds: 500)).then(
                    (_) async {
                      if (!ref.mounted) {
                        return;
                      }
                      final scrollController = ref
                          .read(lobbyScrollControllerProvider)
                          .scrollController;
                      if (scrollController.hasClients) {
                        return scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
