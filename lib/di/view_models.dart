import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/game/view_model/game_page_view_model.dart';
import '../presentation/game/widgets/game_contol/view_model/game_control_view_model.dart';
import '../presentation/game/widgets/game_contol/view_model/game_control_view_model_impl.dart';
import '../presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';
import '../presentation/game/widgets/winner_page/winner_choice_view_model.dart';
import '../presentation/home/home_page_view_model.dart';
import '../presentation/init/init_page_view_model.dart';
import '../presentation/lobby/lobby_bank_editor/bank_editor_view_model.dart';
import '../presentation/lobby/player_editor/view_model/player_editor_view_model.dart';
import '../presentation/lobby/player_list/view_model/saved_player_list_view_model.dart';
import '../presentation/lobby/view_model/lobby_page_view_model.dart';
import '../presentation/onboading/onboarding_view_model.dart';
import '../presentation/settings/view_model/game_settings_view_model.dart';
import 'domain_managers.dart';
import 'model_holders.dart';

final initPageViewModelProvider = Provider.autoDispose<InitPageViewModel>(
  (ref) => InitPageViewModel(
    initializationManager: ref.watch(initializationManagerProvider),
    navigationManager: ref.watch(navigationManagerProvider),
  ),
);

final homePageViewModelProvider = Provider.autoDispose<HomePageViewModel>(
  (ref) => HomePageViewModel(
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    navigationManager: ref.watch(navigationManagerProvider),
    strings: ref.watch(stringsProvider),
  ),
);

final onboardingViewModelProvider = Provider.autoDispose<OnboardingViewModel>(
  (ref) => OnboardingViewModel(
    configModelHolder: ref.watch(configModelHolderProvider),
    navigationManager: ref.watch(navigationManagerProvider),
    strings: ref.watch(stringsProvider),
  ),
);

final lobbyPageViewModelProvider = Provider.autoDispose<LobbyPageViewModel>(
  (ref) => LobbyPageViewModel(
    navigationManager: ref.watch(navigationManagerProvider),
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    savedPlayersModelHolder: ref.watch(savedPlayersModelHolderProvider),
    toastManager: ref.watch(toastManagerProvider),
    addListener: (listener) => ref.listen(
      lobbyStateHolderProvider,
      (_, __) => listener(),
    ),
    strings: ref.watch(stringsProvider),
  ),
);

final savedPlayerListViewModelProvider =
    Provider.autoDispose<SavedPlayerListViewModel>(
  (ref) => SavedPlayerListViewModel(
    modelHolder: ref.read(savedPlayersModelHolderProvider),
    addListener: (listener) => ref.listen(
      savedPlayersModelHolderProvider,
      (_, __) => listener(),
    ),
    navigationManager: ref.watch(navigationManagerProvider),
    strings: ref.watch(stringsProvider),
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    toastManager: ref.watch(toastManagerProvider),
  ),
);

final playerEditorViewModelProvider =
    Provider.autoDispose.family<PlayerEditorViewModel, String?>(
  (ref, uid) => PlayerEditorViewModel(
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    navigationManager: ref.watch(navigationManagerProvider),
    toastManager: ref.watch(toastManagerProvider),
    strings: ref.watch(stringsProvider),
    playerUid: uid,
  ),
);

final bankEditorViewModelProvider = Provider.autoDispose<BankEditorViewModel>(
  (ref) => BankEditorViewModel(
    lobbyStateHolder: ref.watch(lobbyStateHolderProvider),
    pop: () => ref.read(navigationManagerProvider).pop(),
  ),
);

final gamePageViewModelProvider = Provider.autoDispose<GamePageViewModel>(
  (ref) => GamePageViewModel(
    gameStateMachine: ref.watch(gameStateMachineProvider),
    navigationManager: ref.watch(navigationManagerProvider),
    strings: ref.watch(stringsProvider),
  ),
);

final gamePageControlViewModelProvider =
    Provider.autoDispose<GameControlViewModel>(
  (ref) => GameControlViewModelImpl(
    navigationManager: ref.watch(navigationManagerProvider),
    gameStateMachine: ref.watch(gameStateMachineProvider),
  ),
);

final lobbySettingsViewModelProvider =
    Provider.autoDispose<GameSettingsViewModel>(
  (ref) => GameSettingsViewModel(
    gameSettingsProvider: ref.watch(lobbyStateHolderProvider),
    pop: () => ref.watch(navigationManagerProvider).pop(),
  ),
);

final gameSettingsViewModelProvider =
    Provider.autoDispose<GameSettingsViewModel>(
  (ref) => GameSettingsViewModel(
    gameSettingsProvider: ref.watch(gameStateMachineProvider),
    pop: () => ref.watch(navigationManagerProvider).pop(),
  ),
);

final winnerChooseViewModelProvider =
    Provider.autoDispose.family<WinnerChoiceViewModel, WinnerChoiceArgs>(
  (ref, args) => WinnerChoiceViewModel(
    navigationManager: ref.watch(navigationManagerProvider),
    strings: ref.watch(stringsProvider),
    toastManager: ref.watch(toastManagerProvider),
    args: args,
  ),
);
