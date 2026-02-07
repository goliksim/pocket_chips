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
import '../../presentation/monitization/donation_store/donation_page.dart';
import '../../presentation/monitization/pro_version/pro_version_offer_page.dart';
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

  Future<void> showUpdateDialog(String version) => transitionDialog(
        context: context,
        child: Consumer(
          builder: (_, ref, __) => UpdateDialog(version: version),
        ),
      );

  Future<void> showAboutDialog({bool canPop = true}) => transitionDialog(
        context: context,
        child: PopScope(
          canPop: canPop,
          child: AboutDialog(),
        ),
      );

  Future<void> showDonationDialog({bool isTriggered = false}) =>
      transitionDialog(
        context: context,
        child: DonateWindow(
          isTriggered: isTriggered,
        ),
      );

  Future<void> showProVersionOfferDialog() => transitionDialog(
        context: context,
        child: const ProVersionOfferPage(),
      );

  Future<void> showWinnerSolver() => transitionDialog(
        context: context,
        child: const WinnerChecker(),
      );

  Future<void> showSavedPlayers() => transitionDialog(
        type: DialogTransitionType.slideUp,
        context: context,
        child: SavedPlayerList(),
      );

  Future<void> showStartingStackEditor() => transitionDialog(
        type: DialogTransitionType.slideUp,
        context: context,
        child: Consumer(
          builder: (_, ref, __) => BankEditorDialog(
            viewModel: ref.watch(bankEditorViewModelProvider),
          ),
        ),
      );

  Future<void> showLobbySettings() => transitionDialog(
        type: DialogTransitionType.slideDown,
        context: context,
        child: Consumer(
          builder: (_, ref, __) => GameSettingsDialog(
            viewModel: ref.watch(lobbySettingsViewModelProvider),
          ),
        ),
      );

  Future<void> showPlayerEditor(PlayerId? playerUid) => transitionDialog(
        context: context,
        child: Consumer(
          builder: (_, ref, __) => PlayerEditorPage(
            viewModel: ref.watch(
              playerEditorViewModelProvider(playerUid),
            ),
          ),
        ),
      );

  Future<String?> openPlayerLogoEditor() => showGeneralDialog<String>(
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        barrierLabel: 'PlayerLogoPicker',
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
      );

  Future<Set<String>?> showWinnerChooseDialog(
    WinnerChoiceArgs args,
  ) =>
      transitionDialog<Set<String>>(
        barrierDismissible: false,
        context: context,
        child: Consumer(
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

  bool handleBackNavigation() {
    if (ModalRoute.of(context)?.isCurrent == true &&
        ModalRoute.of(context) is! PageRoute) {
      Navigator.of(context).pop();
      return true;
    } else {
      return _popPage();
    }
  }

  bool _popPage() {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }
}
