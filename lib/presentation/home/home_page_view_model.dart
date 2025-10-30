import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigation/models/app_route.dart';
import '../../app/navigation/navigation_manager.dart';
import '../../domain/model_holders/lobby_state_holder.dart';
import '../../domain/models/game/game_state_enum.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/logs.dart';

class HomePageViewModel with ChangeNotifier {
  final LobbyStateHolder _lobbyStateHolder;
  final NavigationManager _navigationManager;
  final AppLocalizations _strings;

  late bool hasActiveLobby;
  bool isLoading = true;

  HomePageViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required NavigationManager navigationManager,
    required AppLocalizations strings,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _navigationManager = navigationManager,
        _strings = strings {
    _init();
  }

  Future<void> _init() async {
    _lobbyStateHolder.state.whenData((lobby) {
      hasActiveLobby = (lobby != null);
      isLoading = false;

      notifyListeners();
    });
  }

  Future<void> showAboutInfo() => _navigationManager.showAboutDialog(
        canPop: true,
      );

  //TODO: implement
  void changeTheme() {
    throw UnimplementedError();
    /*Navigator.pushReplacement(
                    context,
                    simpleThemePageRoute(
                      HomePage(isDark: !widget.isDark),
                    ),
                  );*/
  }

  Future<void> createNewGame() async {
    final gameState = _lobbyStateHolder.dataOrNull?.gameState;

    if (gameState == null || gameState.isNotStarted) {
      return _createNewGame();
    } else {
      await _navigationManager.showConfirmationDialog(
        title: _strings.home_new,
        actionTitle: _strings.home_new,
        message: '${_strings.conf_new_text1}\n${_strings.conf_new_text2}',
        action: _createNewGame,
      );
    }
  }

  void continueGame() async {
    logs.writeLog('Switch to PlayerPage(Continue)');

    return _navigationManager.goTo(AppRoute.lobby());
  }

  Future<void> showWinnerSolver() => _navigationManager.showWinnerSolver();

  void _createNewGame() {
    _lobbyStateHolder.createNewLobby();

    logs.writeLog('Switch to PlayerPage(NewGame)');
    _navigationManager.goTo(
      AppRoute.lobby(),
    );
  }
}
