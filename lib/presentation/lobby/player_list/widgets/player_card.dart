import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../view_state/lobby_player_item.dart';

class PlayerCard extends StatelessWidget {
  final LobbyPlayerItem player;
  final bool canReorderOrDismiss;
  final bool isSaved;

  final Future<bool?> Function()? rightCallback;
  final Future<bool?> Function()? leftCallback;
  final VoidCallback? onTap;

  const PlayerCard({
    required this.player,
    required this.canReorderOrDismiss,
    this.leftCallback,
    this.rightCallback,
    this.onTap,
    super.key,
  }) : isSaved = false;

  const PlayerCard.saved({
    required this.player,
    this.leftCallback,
    this.rightCallback,
    this.onTap,
    super.key,
  })  : isSaved = true,
        canReorderOrDismiss = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(player.name),
      direction: canReorderOrDismiss
          ? DismissDirection.horizontal
          : DismissDirection.none,
      background: Container(
        color: thisTheme.bgrColor,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Icon(
                isSaved ? Icons.add : Icons.save,
                color: thisTheme.onBackground,
                size: stdIconSize,
              ),
            ),
            Text(
              isSaved
                  ? ' ${context.strings.playp_playr_diss1}'
                  : ' ${context.strings.playp_playr_diss2}',
              style: TextStyle(
                color: thisTheme.onBackground,
                fontSize: stdFontSize * 0.75,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: thisTheme.bgrColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              isSaved
                  ? ' ${context.strings.playp_playr_diss3}'
                  : ' ${context.strings.playp_playr_diss4}',
              style: TextStyle(
                color: thisTheme.subsubmainColor,
                fontSize: stdFontSize * 0.75,
              ),
            ),
            AspectRatio(
              aspectRatio: 1,
              child: Icon(
                Icons.delete,
                color: thisTheme.subsubmainColor,
                size: stdIconSize,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async =>
          direction == DismissDirection.startToEnd
              ? rightCallback?.call()
              : leftCallback?.call(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(stdBorderRadius),
        child: GestureDetector(
          onTap: () => onTap?.call(),
          child: Container(
            height: isSaved ? stdButtonHeight * 0.75 : stdButtonHeight,
            color: thisTheme.playerColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Padding(
                          padding:
                              EdgeInsets.all(0.20 * stdButtonHeight * 0.75),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                filterQuality: FilterQuality.medium,
                                image: AssetImage(
                                  player.assetUrl,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: stdButtonHeight * 0.1,
                            vertical: stdButtonHeight * 0.15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${player.name}  ', //+ ((index == thisLobby.dealerIndex && !widget.saved)?" - dealer":""),
                                    style: TextStyle(
                                      color: thisTheme.onBackground,
                                      fontWeight: FontWeight.w500,
                                      fontSize: stdFontSize * 0.8,
                                    ),
                                  ),
                                  if (player.isDealer && !isSaved)
                                    Tooltip(
                                      message: context.strings.tooltip_dealer,
                                      verticalOffset: stdButtonHeight / 6,
                                      child: Icon(
                                        MdiIcons.cardsPlaying,
                                        color: thisTheme.onBackground,
                                        size: stdIconSize / 1.5,
                                      ),
                                    ),
                                ],
                              ),
                              if (player.bank != null)
                                Text(
                                  '\$ ${player.bank}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: thisTheme.onBackground,
                                    fontSize: stdFontSize * 0.75,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isSaved && canReorderOrDismiss)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Icon(
                        Icons.drag_handle,
                        color: thisTheme.onBackground,
                        size: stdIconSize * 0.75,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
