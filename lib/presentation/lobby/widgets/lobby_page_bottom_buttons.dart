import 'package:flutter/material.dart';

import '../../../app/keys/keys.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class LobbyPageBottomButtons extends StatelessWidget {
  final VoidCallback onStartGame;
  final VoidCallback openSettingsTap;
  final bool isGameActive;
  final bool canEditSettings;

  const LobbyPageBottomButtons({
    super.key,
    required this.onStartGame,
    required this.openSettingsTap,
    required this.isGameActive,
    required this.canEditSettings,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: canEditSettings
            ? stdButtonHeight * 2 + stdHorizontalOffset
            : stdButtonHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyButton(
              key: LobbyKeys.gameButton,
              height: stdButtonHeight,
              buttonColor: context.theme.primaryColor,
              action: () => onStartGame(),
              textString: isGameActive
                  ? context.strings.home_cont
                  : context.strings.playp_start,
            ),
            // Settings
            if (canEditSettings)
              MyButton(
                key: LobbyKeys.settingsButton,
                height: stdButtonHeight,
                buttonColor: context.theme.secondaryColor,
                action: () => openSettingsTap(),
                textString: context.strings.playp_set,
              ),
          ],
        ),
      );
}
