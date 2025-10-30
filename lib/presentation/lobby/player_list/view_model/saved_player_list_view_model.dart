import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../domain/model_holders/lobby_state_holder.dart';
import '../../../../domain/model_holders/saved_players_model_holder.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/toast_manager.dart';
import '../view_state/lobby_player_item.dart';

class SavedPlayerListViewModel with ChangeNotifier {
  final SavedPlayersModelHolder _modelHolder;
  final LobbyStateHolder _lobbyStateHolder;
  final NavigationManager _navigationManager;
  final ToastManager _toastManager;
  final AppLocalizations _strings;

  late List<LobbyPlayerItem> players;

  SavedPlayerListViewModel({
    required SavedPlayersModelHolder modelHolder,
    required LobbyStateHolder lobbyStateHolder,
    required NavigationManager navigationManager,
    required Function(VoidCallback) addListener,
    required ToastManager toastManager,
    required AppLocalizations strings,
  })  : _modelHolder = modelHolder,
        _lobbyStateHolder = lobbyStateHolder,
        _toastManager = toastManager,
        _navigationManager = navigationManager,
        _strings = strings {
    addListener(_update);

    _init();
  }

  void _init() {
    players = _modelHolder.players
        .map((p) =>
            LobbyPlayerItem(uid: p.uid, name: p.name, assetUrl: p.assetUrl))
        .toList();
  }

  void _update() {
    _init();

    notifyListeners();
  }

  Future<bool> deletePlayer(String playerUid) async {
    final result = await _navigationManager.showConfirmationDialog(
      title: _strings.conf_del_tittle,
      actionTitle: _strings.conf_del_butt,
      message: _strings.conf_del_text,
      action: () => _delete(playerUid),
    );

    return result ?? false;
  }

  Future<bool> usePlayer(String playerUid) async {
    final player =
        players.firstWhereOrNull((p) => p.uid == playerUid)?.toDomain;

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

  Future<void> _delete(String playerUid) async {
    await _modelHolder.removePlayer(playerUid);
  }
}
