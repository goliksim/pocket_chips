import 'package:flutter/material.dart';

import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/widgets/ui_widgets.dart';

class BreakdownButtons extends StatelessWidget {
  final VoidCallback openSettings;
  final VoidCallback startBetting;
  final bool canStartBetting;

  const BreakdownButtons({
    required this.openSettings,
    required this.startBetting,
    required this.canStartBetting,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Flexible(
            flex: 10,
            child: MyButton(
              height: stdButtonHeight,
              width: double.infinity,
              buttonColor: context.theme.additionButtonColor,
              child: AspectRatio(
                aspectRatio: 1,
                child: Icon(
                  Icons.settings,
                  color: context.theme.onPrimary,
                  size: stdIconSize,
                ),
              ),
              action: () => openSettings(),
            ),
          ),
          SizedBox(width: stdHorizontalOffset),
          Expanded(
            flex: 31,
            child: MyButton(
              height: stdButtonHeight,
              width: double.infinity,
              buttonColor: context.theme.primaryColor
                  .withAlpha(canStartBetting ? 255 : 75),
              textStyle: context.theme.stdTextStyle.copyWith(
                fontSize: stdFontSize,
                color: context.theme.onPrimary
                    .withAlpha(canStartBetting ? 255 : 75),
              ),
              textString: context.strings.game_start,
              action: () => startBetting(),
            ),
          ),
        ],
      );
}
