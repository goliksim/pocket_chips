import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigation/models/app_route.dart';
import '../../app/navigation/navigation_manager.dart';
import '../../di/domain_managers.dart';
import '../../di/model_holders.dart';
import '../../di/repositories.dart';
import '../../domain/model_holders/lobby_state_holder.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/logs.dart';

// Храним
class HomePageViewModel extends AsyncNotifier<bool> {
  LobbyStateHolder get _lobbyStateHolder =>
      ref.read(lobbyStateHolderProvider.notifier);
  NavigationManager get _navigationManager =>
      ref.read(navigationManagerProvider);
  AppLocalizations get _strings => ref.watch(stringsProvider);

  @override
  FutureOr<bool> build() async {
    final lobbyState = await ref.read(appRepositoryProvider).getLobbyState();

    return lobbyState != null;
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
    final haveActiveLobby = state.value ?? false;

    if (!haveActiveLobby) {
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
