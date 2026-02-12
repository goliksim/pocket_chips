import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../app/keys/keys.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/empty_asset_filter.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/player_avatar.dart';
import '../../../monitization/pro_version/widgets/pro_version_wrapper.dart';
import '../view_state/lobby_player_item.dart';

class PlayerCard extends StatelessWidget {
  final LobbyPlayerItem player;
  final bool canReorder;
  final bool canDismiss;
  final bool isSaved;

  final Future<bool?> Function()? rightCallback;
  final Future<bool?> Function()? leftCallback;
  final VoidCallback? onTap;

  const PlayerCard({
    required this.player,
    required bool canReorderOrDismiss,
    this.leftCallback,
    this.rightCallback,
    this.onTap,
    super.key,
  })  : isSaved = false,
        canDismiss = canReorderOrDismiss,
        canReorder = canReorderOrDismiss;

  const PlayerCard.saved({
    required this.player,
    this.leftCallback,
    this.rightCallback,
    this.onTap,
    super.key,
  })  : isSaved = true,
        canDismiss = true,
        canReorder = false;

  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key(player.name),
        direction:
            canDismiss ? DismissDirection.horizontal : DismissDirection.none,
        background: Container(
          color: context.theme.bgrColor,
          child: Row(
            children: [
              ProVersionWrapper(
                offset: 10,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Icon(
                    isSaved ? Icons.add : Icons.save,
                    color: context.theme.onBackground,
                    size: stdIconSize,
                  ),
                ),
              ),
              Text(
                isSaved
                    ? ' ${context.strings.playp_playr_diss1}'
                    : ' ${context.strings.playp_playr_diss2}',
                style: TextStyle(
                  color: context.theme.onBackground,
                  fontSize: stdFontSize * 0.75,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: context.theme.bgrColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isSaved
                    ? ' ${context.strings.playp_playr_diss3}'
                    : ' ${context.strings.playp_playr_diss4}',
                style: TextStyle(
                  color: context.theme.alertColor,
                  fontSize: stdFontSize * 0.75,
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: Icon(
                  Icons.delete,
                  color: context.theme.alertColor,
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
              color: context.theme.playerColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (canReorder)
                    Padding(
                      key: ValueKey(canReorder),
                      padding: EdgeInsets.only(left: stdHorizontalOffset / 2),
                      child: Icon(
                        Icons.drag_indicator,
                        color: context.theme.onBackground.withAlpha(128),
                        size: stdIconSize * 0.75,
                      ),
                    ),
                  Expanded(
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Padding(
                            padding:
                                EdgeInsets.all(0.20 * stdButtonHeight * 0.75),
                            child: PlayerAvatar(
                              key: LobbyKeys.userAvatarKeyByAsset(
                                player.assetUrl,
                              ),
                              assetUrl: player.assetUrl,
                              colorFilter: (player.assetUrl ==
                                      AssetsProvider.emptyPlayerAsset)
                                  ? EmptyAssetFilter.filter(player.uid)
                                  : null,
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
                                Text(
                                  player.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.theme.onBackground,
                                    fontWeight: FontWeight.w500,
                                    fontSize: stdFontSize * 0.8,
                                  ),
                                ),
                                if (player.bank != null)
                                  Text(
                                    key: LobbyKeys.playerBank(player.bank!),
                                    player.bank!.toSeparatedBank,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: context.theme.onBackground,
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
                  if (player.isDealer && !isSaved)
                    Padding(
                      padding: EdgeInsets.only(
                        right: stdHorizontalOffset +
                            (canReorder ? 0 : stdHorizontalOffset),
                      ),
                      child: Tooltip(
                        message: context.strings.tooltip_dealer,
                        verticalOffset: stdButtonHeight / 6,
                        child: Icon(
                          key: LobbyKeys.dealerIcon,
                          MdiIcons.cardsPlaying,
                          color: context.theme.primaryColor,
                          size: stdIconSize * 0.9,
                        ),
                      ),
                    ),
                  if (canReorder)
                    Padding(
                      padding: EdgeInsets.only(right: stdHorizontalOffset * 2),
                      child: Icon(
                        Icons.edit,
                        color: context.theme.onBackground.withAlpha(128),
                        size: stdIconSize * 0.75,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
