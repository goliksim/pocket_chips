import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/lobby/lobby_state_model.dart';
import '../presentation/game/view_model/game_page_table_offset_controller.dart';
import '../presentation/game/view_model/game_page_view_model.dart';
import '../presentation/game/view_state/game_page_view_state.dart';
import '../presentation/game/widgets/winner_page/view_state/winner_choice_args.dart';
import '../presentation/game/widgets/winner_page/winner_choice_view_model.dart';
import '../presentation/home/home_page_view_model.dart';
import '../presentation/init/init_page_view_model.dart';
import '../presentation/lobby/lobby_bank_editor/bank_editor_view_model.dart';
import '../presentation/lobby/player_editor/view_model/player_editor_view_model.dart';
import '../presentation/lobby/player_list/view_model/saved_player_list_view_model.dart';
import '../presentation/lobby/player_list/view_state/lobby_player_item.dart';
import '../presentation/lobby/view_model/lobby_page_view_model.dart';
import '../presentation/lobby/view_model/lobby_scroll_controller.dart';
import '../presentation/lobby/view_state/lobby_page_state.dart';
import '../presentation/monitization/donation_store/view_model/donation_view_model.dart';
import '../presentation/monitization/donation_store/view_state/donation_view_state.dart';
import '../presentation/monitization/pro_version/view_model/pro_version_offer_view_model.dart';
import '../presentation/monitization/pro_version/view_state/pro_version_offer_view_state.dart';
import '../presentation/onboading/onboarding_view_model.dart';
import '../presentation/onboading/view_state/onboarding_view_state.dart';
import '../presentation/settings/view_model/game_settings_view_model.dart';
import 'domain_managers.dart';
import 'model_holders.dart';

final initPageViewModelProvider = Provider.autoDispose<InitPageViewModel>(
  (ref) => InitPageViewModel(
    initializationManager: ref.read(initializationManagerProvider),
    navigationManager: ref.read(navigationManagerProvider),
  ),
);

final homePageViewModelProvider =
    AsyncNotifierProvider.autoDispose<HomePageViewModel, bool>(
  HomePageViewModel.new,
);

final onboardingViewModelProvider =
    AsyncNotifierProvider.autoDispose<OnboardingViewModel, OnboardingViewState>(
  OnboardingViewModel.new,
);

final lobbyPageViewModelProvider =
    AsyncNotifierProvider.autoDispose<LobbyPageViewModel, LobbyPageState>(
  LobbyPageViewModel.new,
);

final lobbyScrollControllerProvider =
    Provider.autoDispose<LobbyScrollController>(
  (ref) {
    final controller = LobbyScrollController();

    // Don't kill controller while it has subsribers
    ref.keepAlive();
    // Killing controller on provider dispose
    ref.onDispose(() {
      controller.dispose();
    });
    return controller;
  },
);

final savedPlayerListViewModelProvider = AsyncNotifierProvider.autoDispose<
    SavedPlayerListViewModel, List<LobbyPlayerItem>>(
  SavedPlayerListViewModel.new,
);

final playerEditorViewModelProvider =
    Provider.autoDispose.family<PlayerEditorViewModel, String?>(
  (ref, uid) => PlayerEditorViewModel(
    lobbyStateHolder: ref.read(lobbyStateHolderProvider.notifier),
    savedPlayersModelHolder: ref.read(savedPlayersModelHolderProvider.notifier),
    navigationManager: ref.read(navigationManagerProvider),
    toastManager: ref.read(toastManagerProvider),
    strings: ref.read(stringsProvider),
    playerUid: uid,
  ),
);

final bankEditorViewModelProvider = Provider.autoDispose<BankEditorViewModel>(
  (ref) {
    final lobbyState = ref.read(lobbyStateHolderProvider).requireValue;

    return BankEditorViewModel(
      lobbyStateHolder: ref.read(lobbyStateHolderProvider.notifier),
      toastManager: ref.read(toastManagerProvider),
      strings: ref.read(stringsProvider),
      pop: () => ref.read(navigationManagerProvider).pop(),
      currentDefaultBank: lobbyState.defaultBank,
      minRecommendedStartingStack: lobbyState.minRecommendedStartingStack,
    );
  },
);

final gamePageViewModelProvider =
    AsyncNotifierProvider.autoDispose<GamePageViewModel, GamePageViewState>(
  GamePageViewModel.new,
);

final gameTableOffsetControllerProvider =
    NotifierProvider<GameTableOffsetController, int>(
  GameTableOffsetController.new,
);

final lobbySettingsViewModelProvider =
    Provider.autoDispose<GameSettingsViewModel>(
  (ref) => GameSettingsViewModel(
    gameSettingsProvider: ref.read(lobbyStateHolderProvider.notifier),
    pop: () => ref.read(navigationManagerProvider).pop(),
  ),
);

final winnerChooseViewModelProvider =
    Provider.autoDispose.family<WinnerChoiceViewModel, WinnerChoiceArgs>(
  (ref, args) => WinnerChoiceViewModel(
    navigationManager: ref.read(navigationManagerProvider),
    toastManager: ref.read(toastManagerProvider),
    strings: ref.read(stringsProvider),
    args: args,
  ),
);

final donationViewModelProvider =
    AsyncNotifierProvider.autoDispose<DonationViewModel, DonationViewState>(
  DonationViewModel.new,
);

final proVersionOfferViewModelProvider = AsyncNotifierProvider.autoDispose<
    ProVersionOfferViewModel, ProVersionOfferViewState>(
  ProVersionOfferViewModel.new,
);
