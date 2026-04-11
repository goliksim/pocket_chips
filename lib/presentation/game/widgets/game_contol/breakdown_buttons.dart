import 'package:flutter/material.dart';

import '../../../../app/keys/keys.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/widgets/ui_widgets.dart';

class BreakdownButtons extends StatelessWidget {
  final VoidCallback openSettings;
  final VoidCallback startBetting;
  final VoidCallback increaseLevel;
  final bool canStartBetting;
  final bool canIncreaseLevel;

  const BreakdownButtons({
    required this.openSettings,
    required this.startBetting,
    required this.canStartBetting,
    required this.canIncreaseLevel,
    required this.increaseLevel,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Flexible(
            flex: 10,
            child: MyButton(
              key: GameKeys.settingsButton,
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
          SizedBox(width: stdHorizontalOffset / 2),
          Expanded(
            flex: canIncreaseLevel ? 20 : 31,
            child: MyButton(
              key: GameKeys.startGameButton,
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
          if (canIncreaseLevel) ...[
            SizedBox(width: stdHorizontalOffset / 2),
            Flexible(
              flex: 10,
              child: Tooltip(
                message: context.strings.tooltip_increase_level,
                child: MyButton(
                  key: GameKeys.increaseLevelButton,
                  height: stdButtonHeight,
                  width: double.infinity,
                  buttonColor: context.theme.secondaryColor,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Icon(
                      Icons.keyboard_double_arrow_up,
                      color: context.theme.onPrimary,
                      size: stdIconSize,
                    ),
                  ),
                  action: () => increaseLevel(),
                ),
              ),
            ),
          ],
        ],
      );
}
