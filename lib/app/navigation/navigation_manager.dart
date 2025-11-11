import 'package:flutter/material.dart' hide AboutDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../domain/models/player/player_id.dart';
import '../../domain/models/player/player_model.dart';
import '../../presentation/common/transitions.dart';
import '../../presentation/common/widgets/ui_widgets.dart';
import '../../presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';
import '../../presentation/game/widgets/winner_page/winner_choice_page.dart';
import '../../presentation/game/widgets/winner_page/winner_page.dart';
import '../../presentation/lobby/lobby_bank_editor/bank_editor_dialog.dart';
import '../../presentation/lobby/player_editor/player_editor.dart';
import '../../presentation/lobby/player_editor/widgets/player_logo_picker.dart';
import '../../presentation/lobby/player_list/saved_player_list_view.dart';
import '../../presentation/onboading/dialogs/about.dart';
import '../../presentation/onboading/dialogs/update.dart';
import '../../presentation/settings/game_settings_dialog.dart';
import '../../presentation/winner_check/winner_check.dart';
import 'models/app_pages.dart';
import 'models/app_route.dart';

class NavigationManager extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;

  List<AppRoute> _stack = [AppRoute.init()];

  NavigationManager({
    required this.navigatorKey,
  });

  AppRoute get state => _stack.last;
  List<AppRoute> get stack => List.unmodifiable(_stack);
  BuildContext get context => navigatorKey.currentState!.context;

  void goTo(AppRoute routeTarget) {
    if (_stack.length == 1 &&
        _stack.first.page == AppPage.init &&
        routeTarget.page == AppPage.menu) {
      _stack = [routeTarget];
      notifyListeners();
      return;
    }

    if (_stack.isNotEmpty && _stack.last.page == routeTarget.page) {
      _stack[_stack.length - 1] = routeTarget;
      notifyListeners();
      return;
    }

    _stack.add(routeTarget);
    notifyListeners();
  }

  Future<T?> showBottomSheet<T>(Widget modal) => showModalBottomSheet<T>(
        context: context,
        builder: (_) => modal,
      );

  Future<void> showUpdateDialog() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        context: context,
        child: Consumer(
          builder: (_, ref, __) => UpdateDialog(
            viewModel: ref.watch(onboardingViewModelProvider.notifier),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => UpdateDialog(
            viewModel: ref.watch(onboardingViewModelProvider.notifier),
          ),
        ),
      );

  Future<void> showAboutDialog({bool canPop = true}) => transitionDialog(
        duration: const Duration(milliseconds: 400),
        context: context,
        child: PopScope(
          canPop: canPop,
          child: AboutDialog(),
        ),
        builder: (BuildContext context) => AboutDialog(),
      );

  Future<void> showWinnerSolver() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        context: context,
        child: const WinnerChecker(),
        builder: (BuildContext context) => const WinnerChecker(),
      );

  Future<void> showSavedPlayers() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: DialogTransitionType.slideUp,
        context: context,
        child: SavedPlayerList(),
        builder: (BuildContext context) => SavedPlayerList(),
      );

  Future<void> showStartingStackEditor() => transitionDialog(
        type: DialogTransitionType.slideUp,
        context: context,
        duration: const Duration(milliseconds: 400),
        child: Consumer(
          builder: (_, ref, __) => BankEditorDialog(
            viewModel: ref.watch(bankEditorViewModelProvider),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => BankEditorDialog(
            viewModel: ref.watch(bankEditorViewModelProvider),
          ),
        ),
      );

  Future<void> showLobbySettings() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: DialogTransitionType.slideDown,
        context: context,
        child: Consumer(
          builder: (_, ref, __) => GameSettingsDialog(
            viewModel: ref.watch(lobbySettingsViewModelProvider),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => GameSettingsDialog(
            viewModel: ref.watch(lobbySettingsViewModelProvider),
          ),
        ),
      );

  Future<void> showPlayerEditor(PlayerId? playerUid) => transitionDialog(
        duration: const Duration(milliseconds: 400),
        context: context,
        child: Consumer(
          builder: (_, ref, __) => PlayerEditorPage(
            viewModel: ref.watch(
              playerEditorViewModelProvider(playerUid),
            ),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => PlayerEditorPage(
            viewModel: ref.watch(
              playerEditorViewModelProvider(playerUid),
            ),
          ),
        ),
      );

  Future<String?> openPlayerLogoEditor() => showGeneralDialog<String>(
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (_, __, ___) => PlayerLogoPicker(),
        transitionBuilder: dialogWaveBuilder,
      );

  Future<void> showWinner(PlayerModel winner) => transitionDialog(
        duration: const Duration(milliseconds: 500),
        context: context,
        child: WinnerWindow(
          winner: winner,
          pop: pop,
        ),
        builder: (_) => WinnerWindow(
          winner: winner,
          pop: pop,
        ),
      );

  Future<Set<String>?> showWinnerChooseDialog(
    WinnerChoiceArgs args,
  ) =>
      transitionDialog<Set<String>>(
        barrierDismissible: false,
        duration: const Duration(milliseconds: 400),
        context: context,
        child: Consumer(
          builder: (_, ref, __) => WinnerChoiceWindow(
            title: args.title,
            viewModel: ref.watch(
              winnerChooseViewModelProvider(args),
            ),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => WinnerChoiceWindow(
            title: args.title,
            viewModel: ref.watch(
              winnerChooseViewModelProvider(args),
            ),
          ),
        ),
      );

  Future<bool?> showConfirmationDialog({
    required String title,
    required String actionTitle,
    required VoidCallback action,
    required String message,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (BuildContext thisContext) => ConfirmationWindow(
          title: title,
          actionTitle: actionTitle,
          message: message,
          action: () => action(),
        ),
      );

  void pop() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void popPage() {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
      return;
    }
  }
}
