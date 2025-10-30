import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class LobbyResetButton extends StatelessWidget {
  final VoidCallback onTap;

  const LobbyResetButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      side: BorderSide(width: 2.5, color: thisTheme.subsubmainColor),
      height: stdButtonHeight,
      buttonColor: thisTheme.playerColor,
      action: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Icon(
              MdiIcons.pokerChip,
              color: thisTheme.onPrimary.withAlpha(0),
              size: stdIconSize,
            ),
          ),
          Text(
            context.strings.playp_rest,
            style: TextStyle(
              fontSize: stdFontSize,
              color: thisTheme.onBackground,
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Icon(
              Icons.sync_sharp,
              color: thisTheme.subsubmainColor,
              size: stdIconSize,
            ),
          ),
        ],
      ),
    );
  }
}
