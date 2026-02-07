import 'package:flutter/material.dart';

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

  const PlayerField({
    required this.player,
    required this.shouldReverse,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        key: GameTableKeys.playerCard(player.name),
        duration: const Duration(milliseconds: 300),
        height: stdHeight,
        width: stdHeight * 2.2,
        child: Opacity(
          opacity: player.isFolded ? 0.4 : 1.0,
          child: MyButton(
            borderRadius: BorderRadius.circular(stdBorderRadius * 2),
            height: stdHeight,
            buttonColor: player.isCurrent
                ? context.theme.primaryColor
                : context.theme.bankColor,
            //longAction: () async {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: shouldReverse
                  ? List.from(
                      _reversablePlayerWidgetList(player, context).reversed)
                  : _reversablePlayerWidgetList(player, context),
            ),
          ),
        ),
      );
}

List<Widget> _reversablePlayerWidgetList(
  GamePlayerItem player,
  BuildContext context,
) =>
    [
      Stack(
        key: player.isCurrent
            ? GameTableKeys.currentPlayerMarker(player.name)
            : null,
        children: [
          SizedBox(
            width: stdHeight,
            height: stdHeight,
            child: PlayerAvatar(
              assetUrl: player.assetUrl,
              colorFilter: (player.assetUrl == AssetsProvider.emptyPlayerAsset)
                  ? EmptyAssetFilter(player.uid)
                  : null,
            ),
          ),
          player.isDealer
              ? Container(
                  width: stdHeight,
                  height: stdHeight,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      filterQuality: FilterQuality.medium,
                      image: AssetsProvider.dealerAsset,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              : Container(),
        ],
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
