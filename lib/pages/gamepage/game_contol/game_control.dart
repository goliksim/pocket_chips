import 'package:flutter/material.dart';
import 'package:pocket_chips/data/lobby.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/internal/gamelogic.dart';
import 'control_widgets/control_buttons/control_buttons.dart';
import 'control_widgets/control_buttons/raise_buttons.dart';
import 'control_widgets/control_buttons/start_field.dart';
import 'control_widgets/raise_field.dart';

class GameControl extends StatefulWidget {
  const GameControl({super.key, required this.callback});
  final Function() callback;
  @override
  State<GameControl> createState() => _GameControlState();
}

class _GameControlState extends State<GameControl> {
  late bool raiseButtonPressed;
  late int tmpBid;
  late int minBid;

  @override
  void initState() {
    print('raiseButtonPressed = false');
    raiseButtonPressed = false;
    tmpBid = thisGame.raiseBank;
    minBid = tmpBid;
    super.initState();
  }

  void changeBid(int newBank) {
    setState(() {
      tmpBid = newBank;
    });
  }

  void changeRaiseBool(value) {
    setState(() {
      raiseButtonPressed = value;
      if (!value) reset();
    });
  }

  void reset() {
    thisGame.raiseBank = thisGame.minTmpFunction(thisGame.bidsEqual);
    tmpBid = thisGame.raiseBank;
    minBid = tmpBid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: stdButtonHeight * 1.6,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.ease,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              height: 2 * stdButtonHeight * 0.75 + stdHorizontalOffset / 2,
              key: ValueKey(raiseButtonPressed),
              child: raiseButtonPressed
                  ? StaticRaiseButton(
                      newPlayer: thisGame.newPlayer,
                      changeBid: changeBid,
                      tmpBid: tmpBid,
                      minBid: minBid,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: stdHorizontalOffset),
        // Панелька нижних кнопок
        (thisLobby.lobbyState != 5)
            ? (!raiseButtonPressed
                ? ControlButtons(
                    key: const ValueKey(1),
                    changeRaiseButton: changeRaiseBool,
                    raiseButtonPressed: raiseButtonPressed,
                  )
                : RaiseButtons(
                    key: const ValueKey(2),
                    changeRaiseButton: changeRaiseBool,
                    tmpBid: tmpBid,
                  ))
            : StartGameField(
                callback: widget.callback,
              )
      ],
    );
  }
}
