import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../di/domain_managers.dart';
import '../../../../di/model_holders.dart';
import '../../../../domain/model_holders/lobby_state_holder.dart';
import '../../../../domain/model_holders/saved_players_model_holder.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/toast_manager.dart';
import '../view_state/lobby_player_item.dart';

class SavedPlayerListViewModel extends AsyncNotifier<List<LobbyPlayerItem>> {
  SavedPlayersModelHolder get _modelHolder =>
      ref.read(savedPlayersModelHolderProvider.notifier);
  LobbyStateHolder get _lobbyStateHolder =>
      ref.read(lobbyStateHolderProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  ToastManager get _toastManager => ref.read(toastManagerProvider);
  AppLocalizations get _strings => ref.read(stringsProvider);

  @override
  FutureOr<List<LobbyPlayerItem>> build() async {
    final players = await ref.watch(savedPlayersModelHolderProvider.future);

    return players
        .map(
          (p) => LobbyPlayerItem(
            name: p.name,
            uid: p.uid,
            assetUrl: p.assetUrl,
          ),
        )
        .toList();
  }

  Future<bool> deletePlayer(String playerUid) async {
    final result = await _navigationManager.showConfirmationDialog(
      title: _strings.conf_del_tittle,
      actionTitle: _strings.conf_del_butt,
      message: _strings.conf_del_text,
      action: () {},
    );

    return (result ?? false) ? _delete(playerUid) : Future.value(false);
  }

  Future<bool> usePlayer(String playerUid) async {
    final player = state.requireValue
        .firstWhereOrNull((p) => p.uid == playerUid)
        ?.toDomain;

    if (player == null) {
      return false;
    }

    try {
      await _lobbyStateHolder.addPlayer(
        player: player,
        makeDealer: false,
      );
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());
    }

    return false;
  }

  Future<bool> _delete(String playerUid) async {
    try {
      await _modelHolder.removePlayer(playerUid);

      return true;
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());

      return false;
    }
  }
}
