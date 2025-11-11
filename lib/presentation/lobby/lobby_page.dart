import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/loading_page.dart';
import '../common/widgets/ui_widgets.dart';
import 'player_list/player_list_view.dart';
import 'widgets/attention_add_player_button.dart';
import 'widgets/lobby_page_bottom_buttons.dart';
import 'widgets/lobby_reset_game_button.dart';
import 'widgets/lobby_stack_button.dart';

class LobbyPage extends ConsumerWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(lobbyScrollControllerProvider).scrollController;
    final viewModel = ref.read(lobbyPageViewModelProvider.notifier);

    final stateProvider = ref.watch(lobbyPageViewModelProvider);

    return stateProvider.maybeWhen(
      skipLoadingOnReload: true,
      data: (state) => PatternContainer(
        padding: EdgeInsets.only(
          top: stdCutoutWidth * 0.75,
          bottom: stdCutoutWidthDown * 0.75,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            toolbarHeight: stdButtonHeight * 0.75,
            leading: IconButton(
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
              AspectRatio(
                aspectRatio: 1,
                child: IconButton(
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
                        //PlayerList
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

                        /*if (players.length > standartPlayerCount)
                        SizedBox(
                          height: stdHorizontalOffset / 2,
                          width: double.infinity,
                        ),*/
                        if (state.canAddPlayer)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: stdHorizontalOffset / 2,
                            ),
                            child: AttentionAddPlayerButton(
                              onTap: () => viewModel.openNewPlayerEditor(),
                              needToAnimate: () => state.players.isEmpty,
                            ),
                          ),
                        //FreeSpace
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
      orElse: () => const LoadingPage(),
    );
  }
}
