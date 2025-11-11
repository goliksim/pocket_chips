// Класс отрисовки списка игроков. Принимает массив (this/saved), метод добавления, bool значение this или saved и функцию отрисовки.
// В дальнейшем думал сделать перемещение игроков местами но пока не получилось.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../di/view_models.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import 'widgets/player_card.dart';

class SavedPlayerList extends ConsumerWidget {
  SavedPlayerList({
    super.key,
  });

  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> reorderableIndex = ValueNotifier(-1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(savedPlayerListViewModelProvider.notifier);
    final asyncData = ref.watch(savedPlayerListViewModelProvider);

    return asyncData.maybeWhen(
      skipLoadingOnReload: true,
      orElse: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (players) => Dialog(
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Container(
          padding: EdgeInsets.all(stdHorizontalOffset),
          width: stdButtonWidth,
          height: stdHorizontalOffset * 2 +
              stdButtonHeight * 0.75 * 0.5 +
              (stdButtonHeight * 0.75 + stdHorizontalOffset / 2) *
                  (players.length > standartPlayerCount
                      ? standartPlayerCount
                      : players.length),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: stdButtonHeight * 0.75 * 0.5,
                child: Center(
                  child: players.isNotEmpty
                      ? Text(
                          context.strings.playp_sp_title1,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: stdFontSize,
                          ),
                        )
                      : Text(
                          context.strings.playp_sp_title2,
                          style: TextStyle(
                            color: context.theme.onBackground,
                            fontWeight: FontWeight.w500,
                            fontSize: stdFontSize,
                          ),
                        ),
                ),
              ),
              if (players.isNotEmpty) SizedBox(height: stdHorizontalOffset / 2),
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height:
                          (stdButtonHeight * 0.75 + stdHorizontalOffset / 2) *
                              players.length,
                      child: Column(
                        children: <Widget>[
                          for (int index = 0; index < players.length; index++)
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    stdBorderRadius,
                                  ),
                                  child: PlayerCard.saved(
                                    player: players[index],
                                    rightCallback: () =>
                                        viewModel.usePlayer(players[index].uid),
                                    leftCallback: () => viewModel
                                        .deletePlayer(players[index].uid),
                                  ),
                                ),
                                SizedBox(
                                  height: stdHorizontalOffset / 2,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
