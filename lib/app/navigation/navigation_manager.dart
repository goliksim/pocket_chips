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
import 'models/app_route.dart';

class NavigationManager extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  AppRoute _state = AppRoute.init();

  NavigationManager({
    required this.navigatorKey,
  });

  AppRoute get state => _state;
  BuildContext get context => navigatorKey.currentState!.context;

  void goTo(AppRoute routeTarget) {
    _state = routeTarget;
    notifyListeners();
  }

  Future<T?> showBottomSheet<T>(Widget modal) => showModalBottomSheet<T>(
        context: context,
        builder: (_) => modal,
      );

  Future<void> showUpdateDialog() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'Scale',
        context: context,
        child: Consumer(
          builder: (_, ref, __) => UpdateDialog(
            viewModel: ref.watch(onboardingViewModelProvider),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => UpdateDialog(
              viewModel: ref.watch(onboardingViewModelProvider),
            ),
          );
        },
      );

  Future<void> showAboutDialog({bool canPop = true}) => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'Scale',
        context: context,
        child: PopScope(
          canPop: canPop,
          child: Consumer(
            builder: (_, ref, __) => AboutDialog(
              viewModel: ref.watch(onboardingViewModelProvider),
            ),
          ),
        ),
        builder: (BuildContext context) => Consumer(
          builder: (_, ref, __) => AboutDialog(
            viewModel: ref.watch(onboardingViewModelProvider),
          ),
        ),
      );

  Future<void> showWinnerSolver() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'Scale',
        context: context,
        child: const WinnerChecker(),
        builder: (BuildContext context) {
          return const WinnerChecker();
        },
      );

  Future<void> showSavedPlayers() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'SlideUp',
        context: context,
        child: Consumer(
          builder: (_, ref, __) => SavedPlayerList(
            viewModel: ref.watch(savedPlayerListViewModelProvider),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => SavedPlayerList(
              viewModel: ref.watch(savedPlayerListViewModelProvider),
            ),
          );
        },
      );

  Future<void> showStartingStackEditor() => transitionDialog(
        type: 'SlideUp',
        context: context,
        duration: const Duration(milliseconds: 400),
        child: Consumer(
          builder: (_, ref, __) => BankEditorDialog(
            viewModel: ref.watch(bankEditorViewModelProvider),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => BankEditorDialog(
              viewModel: ref.watch(bankEditorViewModelProvider),
            ),
          );
        },
      );

  Future<void> showLobbySettings() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'SlideDown',
        context: context,
        child: Consumer(
          builder: (_, ref, __) => GameSettingsDialog(
            viewModel: ref.watch(lobbySettingsViewModelProvider),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => GameSettingsDialog(
              viewModel: ref.watch(lobbySettingsViewModelProvider),
            ),
          );
        },
      );

  Future<void> showGameSettings() => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'SlideDown',
        context: context,
        child: Consumer(
          builder: (_, ref, __) => GameSettingsDialog(
            viewModel: ref.watch(gameSettingsViewModelProvider),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => GameSettingsDialog(
              viewModel: ref.watch(gameSettingsViewModelProvider),
            ),
          );
        },
      );

  Future<void> showPlayerEditor(PlayerId? playerUid) => transitionDialog(
        duration: const Duration(milliseconds: 400),
        type: 'Scale1',
        //barrierColor: null,
        context: context,
        child: Consumer(
          builder: (_, ref, __) => PlayerEditorPage(
            viewModel: ref.watch(
              playerEditorViewModelProvider(playerUid),
            ),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => PlayerEditorPage(
              viewModel: ref.watch(
                playerEditorViewModelProvider(playerUid),
              ),
            ),
          );
        },
      );

  Future<String?> openPlayerLogoEditor() => showGeneralDialog<String>(
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 400),
        context: context,
        pageBuilder: (_, __, ___) {
          return PlayerLogoPicker();
        },
        transitionBuilder: dialogWave1,
      );

  Future<void> showWinner(PlayerModel winner) async {
    showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return WinnerWindow(
          winner: winner,
        );
      },
      transitionBuilder: getTransition('Scale1'),
    );
  }

  Future<Set<String>?> showWinnerChooseDialog(
    WinnerChoiceArgs args,
  ) =>
      transitionDialog<Set<String>>(
        barrierDismissible: false,
        duration: const Duration(milliseconds: 400),
        type: 'Scale1',
        context: context,
        child: Consumer(
          builder: (_, ref, __) => WinnerChoiceWindow(
            title: args.title,
            viewModel: ref.watch(
              winnerChooseViewModelProvider(args),
            ),
          ),
        ),
        builder: (BuildContext context) {
          return Consumer(
            builder: (_, ref, __) => WinnerChoiceWindow(
              title: args.title,
              viewModel: ref.watch(
                winnerChooseViewModelProvider(args),
              ),
            ),
          );
        },
      );

  Future<bool?> showConfirmationDialog({
    required String title,
    required String actionTitle,
    required VoidCallback action,
    required String message,
  }) =>
      showDialog<bool>(
        context: context,
        builder: (BuildContext thisContext) {
          return ConfirmationWindow(
            title: title,
            actionTitle: actionTitle,
            message: message,
            action: () => action(),
          );
        },
      );

  void pop() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }

    _state.maybeMap(
      orElse: () {},
      lobby: (_) => goTo(AppRoute.menu()),
      game: (_) => goTo(AppRoute.lobby()),
    );
  }
}
