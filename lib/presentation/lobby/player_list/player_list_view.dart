// Класс отрисовки списка игроков. Принимает массив (this/saved), метод добавления, bool значение this или saved и функцию отрисовки.
// В дальнейшем думал сделать перемещение игроков местами но пока не получилось.
import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import 'view_state/lobby_player_item.dart';
import 'widgets/player_card.dart';

class PlayerList extends StatelessWidget {
  final List<LobbyPlayerItem> players;
  final bool canReorder;
  final Function(int oldIndex, int newIndex) onReorder;

  final Future<bool> Function(String playerUid)? rightItemCallback;
  final Future<bool> Function(String playerUid)? leftItemCallback;
  final void Function(String playerUid)? onItemTap;

  PlayerList({
    required this.players,
    required this.canReorder,
    required this.onReorder,
    this.scrollController,
    this.rightItemCallback,
    this.leftItemCallback,
    this.onItemTap,
    super.key,
  });

  final ScrollController? scrollController;
  final ValueNotifier<int> reorderableIndex = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(stdBorderRadius),
        child: SizedBox(
          height: players.length * (stdButtonHeight + stdHorizontalOffset),
          child: ReorderableListView.builder(
            buildDefaultDragHandles: canReorder,
            scrollController: scrollController,
            proxyDecorator: proxyDecorator,
            onReorderStart: (index) {
              if (canReorder) {
                reorderableIndex.value = index;
              }
            },
            onReorderEnd: (index) {
              if (canReorder) {
                reorderableIndex.value = -1;
              }
            },
            onReorder: onReorder,
            physics: const BouncingScrollPhysics(),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];

              return Padding(
                key: ValueKey(player.uid),
                padding:
                    EdgeInsets.symmetric(vertical: stdHorizontalOffset / 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  child: ValueListenableBuilder<int>(
                    valueListenable: reorderableIndex,
                    builder: (BuildContext context, int value, Widget? child) =>
                        _ReorderableWrapper(
                      isOrdering: index == value,
                      child: PlayerCard(
                        canReorderOrDismiss: canReorder,
                        player: player,
                        rightCallback: () =>
                            rightItemCallback?.call(player.uid) ??
                            Future.value(false),
                        leftCallback: () =>
                            leftItemCallback?.call(player.uid) ??
                            Future.value(false),
                        onTap: () => onItemTap?.call(player.uid),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

class _ReorderableWrapper extends StatelessWidget {
  final Widget child;
  final bool isOrdering;

  const _ReorderableWrapper({
    required this.child,
    required this.isOrdering,
  });

  @override
  Widget build(BuildContext context) => isOrdering
      ? Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(stdBorderRadius),
            side: BorderSide(
              color: context.theme.primaryColor,
            ),
          ),
          child: child,
        )
      : child;
}
