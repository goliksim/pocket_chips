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
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyButton(
          height: stdButtonHeight,
          width: stdButtonHeight,
          buttonColor: thisTheme.additionButtonColor,
          child: AspectRatio(
            aspectRatio: 1,
            child: Icon(
              Icons.settings,
              color: thisTheme.onPrimary,
              size: stdIconSize,
              //size: stdIconSize,
            ),
          ),
          action: () => openSettings(),
        ),
        SizedBox(width: stdHorizontalOffset),
        Expanded(
          child: MyButton(
            height: stdButtonHeight,
            width: double.infinity,
            buttonColor:
                thisTheme.primaryColor.withAlpha(canStartBetting ? 255 : 75),
            textStyle: stdTextStyle.copyWith(
              fontSize: stdFontSize,
              color: thisTheme.onPrimary.withAlpha(canStartBetting ? 255 : 75),
            ),
            textString: context.strings.game_start,
            action: () => startBetting(),
          ),
        ),
      ],
    );
  }
}
