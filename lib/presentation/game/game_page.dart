import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/loading_page.dart';
import '../common/widgets/ui_widgets.dart';
import '../monitization/ads/app_bar_banner.dart';
import 'widgets/game_contol/game_control.dart';
import 'widgets/game_table/game_table.dart';
import 'widgets/game_title_widget.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(gamePageViewModelProvider.notifier);

    final stateProvider = ref.watch(gamePageViewModelProvider);

    return stateProvider.maybeWhen(
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
              flexibleSpace: const AppBarBanner(),
              toolbarHeight: stdButtonHeight * 0.75,
              leading: IconButton(
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
                gameState: viewState.currentGameState,
                player: viewState.currentPlayerName,
              ),
              centerTitle: true,
              backgroundColor: const Color(0x00000000),
              actions: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: viewState.canEditPlayer
                      ? Transform.scale(
                          scaleX: -1,
                          child: IconButton(
                            icon: Icon(
                              Icons.sync_sharp,
                              color: context.theme.onBackground,
                              size: stdIconSize,
                            ),
                            tooltip: context.strings.tooltip_rot,
                            onPressed: () =>
                                tableOffsetController.increaseOffset(),
                          ),
                        )
                      : const SizedBox(),
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
                    child: GameTable(
                      viewModel: viewModel,
                      tableRotationOffset: tableRotationOffset,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const LoadingPage(),
    );
  }
}
