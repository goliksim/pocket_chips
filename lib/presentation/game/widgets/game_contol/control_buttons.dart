import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';
import '../../../common/widgets/ui_widgets.dart';
import 'view_state/game_control_result.dart';
import 'view_state/game_page_control_state.dart';

class ControlButtons extends StatelessWidget {
  final GamePageActiveControlState state;

  final VoidCallback openRaiseField;
  final void Function(GameControlResult) controlAction;

  const ControlButtons({
    required this.state,
    required this.openRaiseField,
    required this.controlAction,
    super.key,
  });

  //Текст первой кнопки
  String _firstButtonTitle(AppLocalizations strings) {
    if (state.raiseState.raiseIsAllIn) {
      return strings.game_all;
    }

    return state.raiseState.isFirstBet ? strings.game_bet : strings.game_raise;

    /*if (thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank <=
            thisGame.raiseBank &&
        thisLobby.allMoney > thisLobby.maxBid) {
      return context.locale.game_all;
    } else {
      if (thisLobby.betBool && thisLobby.lobbyState != 0) {
        return context.locale.game_bet;
      } else {
        return context.locale.game_raise;
      }
    }*/
  }

  // Реализация кнопки Raise
  void _raiseAction() {
    if (state.raiseState.raiseIsAllIn) {
      controlAction(GameControlResult.allIn());
    }

    openRaiseField();
  }

  //Текст средней кнопки
  String _middleButtonTitle(AppLocalizations strings) {
    return state.mainState.map(
        check: (_) => strings.game_check,
        call: (state) {
          final callText = '${strings.game_call} \$${state.callValue}';

          return state.callIsAllIn ? strings.game_all : callText;
        });

    /*if (state.mainState.canCheck){
      return strings.game_check;
    }

    final callText = '${strings.game_call} \$${(maxBid - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid)}';

    return state.mainState.callIsAllIn? strings.game_all: callText; 

    if (thisLobby.betBool) {
      return context.locale.game_check;
    } else {
      //Call/All IN
      final maxBid = thisLobby.maxBid;
      if (thisLobby.allMoney > maxBid) {
        return '${context.locale.game_call} \$${(maxBid - thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bid)}';
      }
      return context.locale.game_all;
    }*/
  }

  // Реализация средней кнопки
  void _universalAction() {
    state.mainState.map(
      check: (_) {
        controlAction(GameControlResult.check());
      },
      call: (state) {
        if (state.callIsAllIn) {
          controlAction(GameControlResult.allIn());
        } else {
          controlAction(GameControlResult.call());
        }
      },
    );

    /*final maxBid = thisLobby.maxBid;
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
    setState(() {});*/
  }

  bool get _raiseButtonActive => state.raiseState.canRaise;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка подтверждения Raise / Bet
        if (_raiseButtonActive)
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ControlButtonWrapper(
              title: _firstButtonTitle(strings),
              color: thisTheme.primaryColor,
              action: () => _raiseAction(),
            ),
          ),
        SizedBox(width: stdHorizontalOffset),

        Flexible(
          flex: _raiseButtonActive ? 1 : 2,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: _middleButtonTitle(strings),
            color: thisTheme.secondaryColor,
            action: () => _universalAction(),
          ),
        ), // Кнопка Call/Check/Skip
        // Кнопка Fold
        SizedBox(width: stdHorizontalOffset),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: context.strings.game_fold,
            color: thisTheme.additionButtonColor,
            action: () => controlAction(GameControlResult.fold()),
          ),
        ),
      ],
    );
  }
}

class ControlButtonWrapper extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback action;

  const ControlButtonWrapper({
    required this.title,
    required this.color,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      height: stdButtonHeight,
      width: double.infinity,
      buttonColor: color,
      textString: title,
      action: () => action(),
    );
  }
}
