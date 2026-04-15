import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../app/keys/keys.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/empty_asset_filter.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/player_avatar.dart';
import '../../../common/widgets/ui_widgets.dart';
import '../../view_state/game_player_item.dart';

class PlayerField extends StatelessWidget {
  final GamePlayerItem player;

  final bool shouldReverse;
  final VoidCallback? onLongPress;

  const PlayerField({
    required this.player,
    required this.shouldReverse,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Opacity(
        key: GameTableKeys.playerCard(player.name),
        opacity: (player.isFolded || player.isSitOut) ? 0.4 : 1.0,
        child: MyButton(
          buttonColor: player.isCurrent
              ? context.theme.primaryColor
              : context.theme.bankColor,
          longAction: () => onLongPress?.call(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: shouldReverse
                ? List.from(
                    _reversablePlayerWidgetList(player, context).reversed)
                : _reversablePlayerWidgetList(player, context),
          ),
        ),
      );
}

List<Widget> _reversablePlayerWidgetList(
  GamePlayerItem player,
  BuildContext context,
) =>
    [
      AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          fit: StackFit.expand,
          key: player.isCurrent
              ? GameTableKeys.currentPlayerMarker(player.name)
              : null,
          children: [
            PlayerAvatar(
              assetUrl: player.assetUrl,
              colorFilter: (player.assetUrl == AssetsProvider.emptyPlayerAsset)
                  ? EmptyAssetFilter.filter(player.uid)
                  : null,
            ),
            if (player.isSitOut)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    MdiIcons.pause,
                    size: stdIconSize * 1.15,
                    color: Colors.white,
                  ),
                ),
              ),
            if (player.isDealer)
              Image(
                filterQuality: FilterQuality.medium,
                image: AssetsProvider.dealerAsset,
                errorBuilder: (context, error, stackTrace) => Icon(
                  MdiIcons.crown,
                  size: stdIconSize,
                  color: context.theme.onPrimary,
                ),
                fit: BoxFit.fill,
              ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  player.name,
                  style: TextStyle(
                    color: player.isCurrent
                        ? context.theme.onPrimary
                        : context.theme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: stdFontSize,
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    player.bank.toCompactBank,
                    key: GameTableKeys.playerBank(player.name, player.bank),
                    style: TextStyle(
                      fontSize: stdFontSize * 0.75,
                      color: player.isCurrent
                          ? context.theme.onPrimary
                          : context.theme.onBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: stdHorizontalOffset / 2),
    ];
