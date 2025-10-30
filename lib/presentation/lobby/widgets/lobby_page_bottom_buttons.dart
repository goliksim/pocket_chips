import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class LobbyPageBottomButtons extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback openSettingsTap;
  final bool isGameActive;

  const LobbyPageBottomButtons({
    super.key,
    required this.onStartGame,
    required this.openSettingsTap,
    required this.isGameActive,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: stdButtonHeight * 2 + stdHorizontalOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyButton(
            height: stdButtonHeight,
            buttonColor: thisTheme.primaryColor,
            action: () => onStartGame(),
            textString: isGameActive
                ? context.strings.home_cont
                : context.strings.playp_start,
          ),
          // Settings
          MyButton(
            height: stdButtonHeight,
            buttonColor: thisTheme.secondaryColor,
            action: () => openSettingsTap(),
            textString: context.strings.playp_set,
          ),
        ],
      ),
    );
  }
}
