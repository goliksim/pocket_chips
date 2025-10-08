import 'package:flutter/material.dart';

import '../../../../../../domain/game_logic.dart';
import '../../../../../../domain/models/lobby.dart';
import '../../../../../../l10n/localization.dart';
import '../../../../../../utils/theme/uiValues.dart';
import 'control_buttons.dart';

class RaiseButtons extends StatefulWidget {
  const RaiseButtons({
    super.key,
    required this.tmpBid,
    required this.changeRaiseButton,
  });
  final int tmpBid;
  final Function changeRaiseButton;
  @override
  State<RaiseButtons> createState() => _RaiseButtonsState();
}

class _RaiseButtonsState extends State<RaiseButtons> {
  late int tmpBid;

  @override
  void initState() {
    tmpBid = widget.tmpBid;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RaiseButtons oldWidget) {
    setState(() {
      tmpBid = widget.tmpBid;
    });
    super.didUpdateWidget(oldWidget);
  }

  //Текст кнопки подтверждения
  String raiseBetString() {
    // ALL IN
    if (widget.tmpBid == thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank) {
      return context.locale.game_all;
    } else {
      // BET/RAISE
      if (thisLobby.betBool && thisLobby.lobbyState != 0) {
        return '${context.locale.game_bet} \$$tmpBid';
      }
      return '${context.locale.game_raise} \$$tmpBid';
    }
  }

  //Выполняет функцию рейза в количестве raiseBank
  void confirmRaiseBet() {
    thisGame.bet(tmpBid);
    widget.changeRaiseButton(false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка Cancel
        Flexible(
          flex: 100,
          fit: FlexFit.tight,
          child: controlButton(
            context.locale.game_raise_canc,
            thisTheme.subsubmainColor,
            () => widget.changeRaiseButton(false),
          ),
        ),
        SizedBox(width: stdHorizontalOffset),
        // Кнопка подтверждения Raise/Bet
        Flexible(
          flex: 209,
          fit: FlexFit.tight,
          child: controlButton(
            raiseBetString(),
            thisTheme.secondaryColor,
            confirmRaiseBet,
          ),
        ),
      ],
    );
  }
}
