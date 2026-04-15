import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/keys/keys.dart';
import '../../di/view_models.dart';
import '../../l10n/localization_extension.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/error_page.dart';
import '../common/widgets/loading_page.dart';
import '../common/widgets/ui_widgets.dart';
import '../monitization/pro_version/widgets/pro_version_wrapper.dart';
import 'widgets/game_contol/game_control.dart';
import 'widgets/game_progression_widget.dart';
import 'widgets/game_table/game_table.dart';
import 'widgets/game_title_widget.dart';

class GamePage extends ConsumerWidget {
  const GamePage({
    super.key = GameKeys.page,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(gamePageViewModelProvider.notifier);

    final stateProvider = ref.watch(gamePageViewModelProvider);

    return stateProvider.when(
      skipLoadingOnReload: true,
      data: (viewState) {
        final tableOffsetController =
            ref.read(gameTableOffsetControllerProvider.notifier);
        final tableRotationOffset =
            ref.watch(gameTableOffsetControllerProvider);

        return PatternBackground(
          opacity: 0.5,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: stdButtonHeight * 0.75,
              leading: IconButton(
                key: CommonKeys.closePageButton,
                onPressed: () => viewModel.pop(),
                icon: Icon(
                  Icons.arrow_back,
                  size: stdIconSize,
                ),
              ),
              iconTheme: IconThemeData(color: context.theme.onBackground),
              titleTextStyle: context.theme.appBarStyle.copyWith(
                fontSize: stdFontSize / 20 * 22,
              ),
              elevation: 0,
              title: GameTitleWidget(
                key: GameKeys.gameStatusTitle(viewState.gameStatus),
                gameState:
                    context.strings.getGameStateName(viewState.gameStatus),
                player: viewState.currentPlayerName,
              ),
              centerTitle: true,
              backgroundColor: const Color(0x00000000),
              actions: <Widget>[
                if (viewState.canEditPlayer)
                  AspectRatio(
                    aspectRatio: 1,
                    child: Transform.scale(
                      scaleX: -1,
                      child: IconButton(
                        icon: Icon(
                          Icons.sync_sharp,
                          color: context.theme.onBackground.withAlpha(164),
                          size: stdIconSize,
                        ),
                        tooltip: context.strings.tooltip_rot,
                        onPressed: () => tableOffsetController.increaseOffset(),
                      ),
                    ),
                  ),
                if (viewState.canEditPlayer && viewModel.canUndoAction)
                  SizedBox(
                    height: stdIconSize,
                    child: VerticalDivider(
                      color: context.theme.onBackground.withAlpha(164),
                      thickness: 1,
                      width: 0,
                    ),
                  ),
                if (viewModel.canUndoAction)
                  ProVersionWrapper(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: IconButton(
                        key: GameKeys.undoButton,
                        icon: Icon(
                          Icons.restore,
                          color: context.theme.onBackground,
                          size: stdIconSize,
                        ),
                        tooltip: context.strings.tooltip_undo,
                        onPressed: () => viewModel.undoLastAction(),
                      ),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Buttons
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        stdHorizontalOffset,
                        0,
                        stdHorizontalOffset,
                        stdHorizontalOffset,
                      ),
                      child: GameTable(
                        viewModel: viewModel,
                        tableRotationOffset: tableRotationOffset,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    adaptiveOffset,
                    0,
                    adaptiveOffset,
                    adaptiveOffset,
                  ),
                  child: GameControl(
                    viewModel: viewModel,
                    statsWidget:
                        GameProgressionWidget(tableState: viewState.tableState),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingPage(),
      error: (error, trace) => ErrorPage(
        message: 'GamePage error occured:\n $error\n$trace',
        retryCallback: () => viewModel.runBuild(),
        canPop: true,
      ),
    );
  }
}
