import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../domain/models/player/player_model.dart';
import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/empty_asset_filter.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/player_avatar.dart';

class WinnerWindow extends StatefulWidget {
  final PlayerModel winner;
  final VoidCallback pop;

  const WinnerWindow({
    required this.winner,
    required this.pop,
    super.key,
  });

  @override
  State<WinnerWindow> createState() => _WinnerWindowState();
}

class _WinnerWindowState extends State<WinnerWindow> {
  String bgrText = '';

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 100; i++) {
      bgrText += 'winner';
    }
  }

  @override
  Widget build(BuildContext context) => Dialog(
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: [
            (MediaQuery.of(context).size.width - stdButtonHeight * 4) / 2,
            adaptiveOffset,
          ].reduce(max),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
        ),
        child: GestureDetector(
          onTap: () => widget.pop(),
          child: SizedBox(
            height: stdButtonHeight * 4,
            width: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: stdHorizontalOffset / 4),
                    height: stdButtonHeight * 3,
                    width: stdButtonHeight * 4,
                    child: Text(
                      bgrText,
                      overflow: TextOverflow.fade,
                      maxLines: 20,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: context.theme.bankColor.withAlpha(128),
                        fontWeight: FontWeight.w700,
                        fontSize: stdFontSize * 2,
                      ),
                    ),
                  ),
                  Positioned(
                    top: stdButtonHeight / 8,
                    child: PlayerAvatar(
                      assetUrl: widget.winner.assetUrl,
                      radius: (stdButtonHeight * 3) / 2,
                      filterQuality: FilterQuality.high,
                      colorFilter: (widget.winner.assetUrl ==
                              AssetsProvider.emptyPlayerAsset)
                          ? EmptyAssetFilter(widget.winner.uid)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: stdButtonHeight,
                      width: stdButtonHeight * 3,
                      alignment: Alignment.center,
                      child: Text(
                        '${widget.winner.name} ${context.strings.game_win2}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.theme.primaryColor,
                          fontSize: stdFontSize,
                          fontWeight: FontWeight.w500,
                        ),
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
