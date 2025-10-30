import 'package:flutter/material.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/toast_manager.dart';
import 'view_state/possible_winner_item.dart';
import 'view_state/winner_choice_args.dart';

class WinnerChoiceViewModel with ChangeNotifier {
  final NavigationManager _navigationManager;
  final ToastManager _toastManager;
  final AppLocalizations _strings;

  WinnerChoiceViewModel({
    required NavigationManager navigationManager,
    required ToastManager toastManager,
    required AppLocalizations strings,
    required WinnerChoiceArgs args,
  })  : _navigationManager = navigationManager,
        possibleWinners = args.possibleWinners,
        _toastManager = toastManager,
        _strings = strings {
    _init();
  }

  final List<PossibleWinnerItem> possibleWinners;
  Map<String, bool> markedState = {};

  void _init() {
    for (var player in possibleWinners) {
      markedState[player.uid] = false;
    }
    /*logs.writeLog(
        "Still Active players: ${thisLobby.lobbyPlayers.where((e) => e.isActive == true).map(
              (e) => [e.name, e.bid],
            ).join(' / ')}");*/
  }

  void onItemTap(String playerUid) {
    markedState[playerUid] = !markedState[playerUid]!;

    notifyListeners();
  }

  Future<void> showWinnerSolver() => _navigationManager.showWinnerSolver();

  Future<void> confirmChoice() async {
    final markedUids = possibleWinners
        .where(
          (p) => markedState[p.uid] ?? false,
        )
        .map((p) => p.uid)
        .toSet();

    if (markedUids.isNotEmpty) {
      pop(markedUids);

      //await _moneyDistribution();
    } else {
      _toastManager.showToast(_strings.toast_winn);
    }
  }

  void pop(Set<String> markedUids) =>
      Navigator.of(_navigationManager.context).pop(markedUids);
}
