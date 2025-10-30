// Класс отрисовки списка игроков. Принимает массив (this/saved), метод добавления, bool значение this или saved и функцию отрисовки.
// В дальнейшем думал сделать перемещение игроков местами но пока не получилось.
import 'package:flutter/material.dart';

import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import 'view_state/lobby_player_item.dart';
import 'widgets/player_card.dart';

class PlayerList extends StatefulWidget {
  final List<LobbyPlayerItem> players;
  final bool canReorder;
  final Function(int oldIndex, int newIndex) onReorder;

  final Future<bool> Function(String playerUid)? rightItemCallback;
  final Future<bool> Function(String playerUid)? leftItemCallback;
  final void Function(String playerUid)? onItemTap;

  const PlayerList({
    required this.players,
    required this.canReorder,
    required this.onReorder,
    this.rightItemCallback,
    this.leftItemCallback,
    this.onItemTap,
    super.key,
  });

  @override
  PlayerListState createState() => PlayerListState();
}

class PlayerListState extends State<PlayerList> {
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<int> reorderableIndex = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(stdBorderRadius),
      child: SizedBox(
        height: widget.players.length * (stdButtonHeight + stdHorizontalOffset),
        child: ReorderableListView.builder(
          buildDefaultDragHandles: widget.canReorder,
          scrollController: _scrollController,
          proxyDecorator: proxyDecorator,
          onReorderStart: (index) {
            if (widget.canReorder) {
              reorderableIndex.value = index;
            }
          },
          onReorderEnd: (index) {
            if (widget.canReorder) {
              reorderableIndex.value = -1;
            }
          },
          onReorder: widget.onReorder,
          physics: const BouncingScrollPhysics(),
          itemCount: widget.players.length,
          itemBuilder: (context, index) {
            final player = widget.players[index];

            return Padding(
              key: ValueKey(
                player.name + player.assetUrl,
              ),
              padding: EdgeInsets.only(bottom: stdHorizontalOffset),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(stdBorderRadius),
                child: ValueListenableBuilder<int>(
                  valueListenable: reorderableIndex,
                  builder: (BuildContext context, int value, Widget? child) {
                    // This builder will only get called when the _counter
                    // is updated.
                    return _ReorderableWrapper(
                      isOrdering: index == value,
                      child: PlayerCard(
                        canReorderOrDismiss: widget.canReorder,
                        player: player,
                        rightCallback: () =>
                            widget.rightItemCallback?.call(player.uid) ??
                            Future.value(false),
                        leftCallback: () =>
                            widget.leftItemCallback?.call(player.uid) ??
                            Future.value(false),
                        onTap: () => widget.onItemTap?.call(player.uid),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReorderableWrapper extends StatelessWidget {
  final Widget child;
  final bool isOrdering;

  const _ReorderableWrapper({
    required this.child,
    required this.isOrdering,
  });

  @override
  Widget build(BuildContext context) {
    return isOrdering
        ? Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(stdBorderRadius),
              side: BorderSide(
                color: thisTheme.primaryColor,
              ),
            ),
            child: child,
          )
        : child;
  }
}
