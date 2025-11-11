import 'package:flutter/material.dart';

import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
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
        duration: const Duration(milliseconds: 300),
        height: stdHeight,
        width: stdHeight * 2.2,
        child: MyButton(
          borderRadius: BorderRadius.circular(stdBorderRadius * 2),
          height: stdHeight,
          buttonColor: player.isCurrent
              ? context.theme.primaryColor
              : context.theme.bankColor.withAlpha(player.isFolded ? 128 : 255),
          //longAction: () async {},
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
      Stack(
        children: [
          Container(
            width: stdHeight,
            height: stdHeight,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                filterQuality: FilterQuality.medium,
                image: AssetImage(
                  player.assetUrl,
                ),
                colorFilter: ColorFilter.mode(
                  Colors.white.withAlpha(
                    player.isFolded ? 50 : 255,
                  ),
                  BlendMode.modulate,
                ),
                fit: BoxFit.fill,
              ),
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
                      colorFilter: ColorFilter.mode(
                        Colors.white.withAlpha(
                          player.isFolded ? 50 : 255,
                        ),
                        BlendMode.modulate,
                      ),
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
                        : context.theme.onBackground.withAlpha(
                            player.isFolded ? 50 : 255,
                          ),
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
                    style: TextStyle(
                      fontSize: stdFontSize * 0.75,
                      color: player.isCurrent
                          ? context.theme.onPrimary
                          : context.theme.onBackground.withAlpha(
                              player.isFolded ? 50 : 255,
                            ),
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
