import 'package:flutter/material.dart';
import 'package:pocket_chips/data/lobby.dart';
import 'package:pocket_chips/data/logs.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/internal/gamelogic.dart';
import 'package:pocket_chips/internal/localization.dart';
import 'package:pocket_chips/pages/gamepage/winner_page.dart';
import 'package:pocket_chips/ui/ui_widgets.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons({
    super.key,
    required this.raiseButtonPressed,
    required this.changeRaiseButton,
  });
  final bool raiseButtonPressed;
  final Function changeRaiseButton;
  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  void callback() {
    setState(() {});
  }

  //Текст первой кнопки
  String firstButtonString() {
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank <=
            thisGame.raiseBank &&
        thisLobby.allMoney > thisLobby.maxBid) {
      return context.locale.game_all;
    } else {
      if (thisLobby.betBool && thisLobby.lobbyState != 0) {
        return context.locale.game_bet;
      } else {
        return context.locale.game_raise;
      }
    }
  }

  //Текст средней кнопки
  String middleButtonString() {
    //Check
    if (thisLobby.betBool) {
      return context.locale.game_check;
    } else {
      //Call/All IN
      final maxBid = thisLobby.maxBid;
      if (thisLobby.allMoney > maxBid) {
        return '${context.locale.game_call} \$${(maxBid - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid)}';
      }
      return context.locale.game_all;
    }
  }

  // Реализация кнопки Raise
  void raiseAction() {
    //Если денег хватает на рейз -> выводим окошко
    if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank >
        thisGame.raiseBank) {
      widget.changeRaiseButton(true);
    } else {
      //Иначе
      thisGame.allIN();
      widget.changeRaiseButton(false);
    }
    setState(() {});
  }

  // Реализация кнопки Fold
  void foldAction() async {
    logs.writeLog(
      'Fold of ${thisLobby.lobbyPlayers[thisLobby.lobbyIndex].name} with index ${thisLobby.lobbyIndex}',
    );
    if (thisGame.fold()) {
      await showWinner(context);
    }
    widget.changeRaiseButton(false);
    setState(() {});
  }

  // Реализация средней кнопки
  void universalAction() {
    final maxBid = thisLobby.maxBid;
    final bid = thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid;
    //Обычное действие Check/Call/All In
    if (bid == maxBid) {
      thisGame.newPlayer();
    } else {
      if (thisLobby.allMoney > maxBid) {
        // CALL
        thisGame.bet(maxBid - bid);
      } else {
        // ALL IN
        thisGame.allIN();
      }
    }
    widget.changeRaiseButton(false);
    setState(() {});
  }

  bool raiseButtonActiveBool() => (thisLobby.allMoney > thisLobby.maxBid);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка Raise
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: controlButton(
            firstButtonString(),
            thisTheme.primaryColor,
            raiseAction,
            condition: raiseButtonActiveBool(),
          ),
        ),
        SizedBox(width: stdHorizontalOffset),
        // Кнопка подтверждения Raise/Bet
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: controlButton(
            middleButtonString(),
            thisTheme.secondaryColor,
            universalAction,
          ),
        ), // Кнопка Call/Check/Skip
        // Кнопка Fold
        SizedBox(width: stdHorizontalOffset),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: controlButton(
            context.locale.game_fold,
            thisTheme.additionButtonColor,
            foldAction,
          ),
        ),
      ],
    );
  }
}

Widget controlButton(
  String name,
  Color color,
  Function action, {
  bool condition = true,
}) =>
    MyButton(
      height: stdButtonHeight,
      width: double.infinity,
      buttonColor: color.withOpacity((condition) ? 1 : 0.3),
      textString: name,
      action: (condition) ? action : () => DoNothingAction,
    );
