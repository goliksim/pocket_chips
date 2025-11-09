// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../utils/extensions.dart';
import '../../utils/theme/ui_values.dart';
import '../common/widgets/loading_page.dart';
import '../common/widgets/ui_widgets.dart';
import 'widgets/game_contol/game_control.dart';
import 'widgets/game_table/game_table.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(gamePageViewModelProvider.notifier);
    final stateProvider = ref.watch(gamePageViewModelProvider);

    return stateProvider.maybeWhen(
      skipLoadingOnReload: true,
      data: (viewState) => PatternContainer(
        opacity: 0.5,
        padding: EdgeInsets.only(
          top: stdCutoutWidth * 0.75,
          bottom: stdCutoutWidthDown * 0.75,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: stdButtonHeight * 0.75,
            leading: IconButton(
              onPressed: () => viewModel.pop(),
              icon: Icon(
                Icons.arrow_back,
                size: stdIconSize,
              ),
            ),
            iconTheme: IconThemeData(
              color: thisTheme.onBackground, //change your color here
            ),
            titleTextStyle:
                appBarStyle().copyWith(fontSize: stdFontSize / 20 * 22),
            elevation: 0,
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              //TODO MAKE ANIMATION
              child: Text(
                viewState.currentGameState,
                key: ValueKey<String>(
                  viewState.currentGameState,
                ),
                style: TextStyle(
                  color: thisTheme.primaryColor,
                ),
              ),
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
                            Icons.sync_sharp, //Icons.info_outline,
                            color: thisTheme.onBackground,
                            size: stdIconSize,
                          ),
                          tooltip: context.strings.tooltip_rot,
                          onPressed: () {
                            viewModel.mixPlayersPosition();
                            viewModel.changeOffset();
                          },
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
      ),
      orElse: () => const LoadingPage(),
    );
  }
}
