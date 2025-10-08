import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../data/lobby.dart';
import '../../../../../data/uiValues.dart';
import '../../../../../internal/gamelogic.dart';
import '../../../../../internal/localization.dart';
import '../../../../../ui/transitions.dart';
import '../../../../../ui/ui_widgets.dart';
import '../../../../../widgets/lobbySettings.dart';

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
              child: AddSettings(
                thisLobby: thisLobby,
                bankUpdate: thisLobby.bankUpdate,
              ),
              builder: (BuildContext context) {
                return AddSettings(
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
