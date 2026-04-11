import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/keys/keys.dart';
import '../../di/view_models.dart';
import '../../domain/models/lobby/lobby_state_model.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/error_page.dart';
import '../common/widgets/loading_page.dart';
import '../common/widgets/ui_widgets.dart';
import '../monitization/ads/app_bar_banner.dart';
import '../monitization/pro_version/widgets/pro_version_wrapper.dart';
import 'player_list/player_list_view.dart';
import 'widgets/attention_add_player_button.dart';
import 'widgets/lobby_page_bottom_buttons.dart';
import 'widgets/lobby_reset_game_button.dart';
import 'widgets/lobby_stack_button.dart';

class LobbyPage extends ConsumerWidget {
  const LobbyPage({
    super.key = LobbyKeys.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(lobbyScrollControllerProvider).scrollController;
    final viewModel = ref.read(lobbyPageViewModelProvider.notifier);

    final stateProvider = ref.watch(lobbyPageViewModelProvider);

    return stateProvider.when(
      skipLoadingOnReload: true,
      data: (state) => PatternBackground(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            flexibleSpace: const AppBarBanner(),
            scrolledUnderElevation: 0,
            toolbarHeight: stdButtonHeight * 0.75,
            leading: IconButton(
              key: CommonKeys.closePageButton,
              onPressed: () => viewModel.pop(),
              icon: Icon(
                Icons.arrow_back,
                size: stdIconSize,
              ),
            ),
            iconTheme: IconThemeData(
              color: context.theme.onBackground,
            ),
            backgroundColor: const Color(0x00000000),
            titleTextStyle: context.theme.stdTextStyle.copyWith(
              fontSize: stdFontSize / 20 * 24,
              color: context.theme.onBackground,
            ),
            elevation: 0,
            title: Text(context.strings.playp_tittle),
            centerTitle: true,
            actions: <Widget>[
              ProVersionWrapper(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: IconButton(
                    key: LobbyKeys.savedPlayersButton,
                    splashColor: context.theme.bankColor,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.folder_shared,
                      size: stdIconSize,
                    ),
                    tooltip: context.strings.tooltip_stor,
                    onPressed: () => viewModel.openSavedPlayersList(),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: stdButtonWidth,
              margin: EdgeInsets.only(
                bottom: adaptiveOffset,
                left: adaptiveOffset,
                right: adaptiveOffset,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  state.gameActive
                      ? LobbyResetButton(
                          onTap: () => viewModel.resetLobby(),
                        )
                      : LobbyStackButton(
                          onTap: () => viewModel.openStartingStackEditor(),
                          startingStack: state.startingStack,
                        ),
                  SizedBox(
                    height: stdHorizontalOffset,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        // PlayerList
                        Flexible(
                          child: state.players.isNotEmpty
                              ? PlayerList(
                                  scrollController: controller,
                                  players: state.players,
                                  rightItemCallback: viewModel.savePlayer,
                                  leftItemCallback: viewModel.removePlayer,
                                  canReorder: state.canEditPlayers,
                                  onReorder: viewModel.onReorderPlayer,
                                  onItemTap: (uid) {
                                    if (state.canEditPlayers) {
                                      viewModel.openPlayerEditor(uid);
                                    }
                                  },
                                )
                              : const SizedBox(),
                        ),
                        if (state.canAddPlayer)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: stdHorizontalOffset / 2,
                            ),
                            child: ProVersionWrapper(
                              offset: -5,
                              conditionToEnable:
                                  state.players.length < noProPlayerCount,
                              child: AttentionAddPlayerButton(
                                key: LobbyKeys.addPlayerButton,
                                onTap: () => viewModel.openNewPlayerEditor(),
                                needToAnimate: () => state.players.isEmpty,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: stdHorizontalOffset / 2,
                    width: double.infinity,
                  ),
                  LobbyPageBottomButtons(
                    onStartGame: () => viewModel.onStartGame(),
                    openSettingsTap: () => viewModel.onSettingsTap(),
                    isGameActive: state.gameActive,
                    canEditSettings: state.canEditPlayers,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      loading: () => const LoadingPage(),
      error: (error, trace) => ErrorPage(
        message: 'LobbyPage error occured:\n$error\n$trace',
        retryCallback: () => viewModel.runBuild(),
        canPop: true,
      ),
    );
  }
}
