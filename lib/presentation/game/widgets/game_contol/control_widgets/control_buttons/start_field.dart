import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../domain/game_logic.dart';
import '../../../../../../domain/models/lobby.dart';
import '../../../../../../l10n/localization.dart';
import '../../../../../../utils/theme/uiValues.dart';
import '../../../../../common/player/player_editing_page.dart';
import '../../../../../common/transitions.dart';
import '../../../../../common/widgets/ui_widgets.dart';

class StartGameField extends StatelessWidget {
  const StartGameField({super.key, required this.callback});
  final Function() callback;

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
          action: () async {
            await transitionDialog(
              duration: const Duration(milliseconds: 400),
              type: 'SlideDown',
              context: context,
              child: PlayerEditingPage(
                thisLobby: thisLobby,
                bankUpdate: thisLobby.bankUpdate,
              ),
              builder: (BuildContext context) {
                return PlayerEditingPage(
                  thisLobby: thisLobby,
                  bankUpdate: thisLobby.bankUpdate,
                );
              },
            );
            callback();
            SystemChrome.restoreSystemUIOverlays();
          },
        ),
        SizedBox(width: stdHorizontalOffset),
        Expanded(
          child: MyButton(
            height: stdButtonHeight,
            width: double.infinity,
            buttonColor:
                thisTheme.primaryColor.withAlpha(thisGame.canPlay ? 255 : 75),
            textStyle: stdTextStyle.copyWith(
              fontSize: stdFontSize,
              color: thisTheme.onPrimary.withAlpha(thisGame.canPlay ? 255 : 75),
            ),
            textString: context.locale.game_start,
            action: () {
              thisGame.startBetting();
              callback();
            },
          ),
        ),
      ],
    );
  }
}
