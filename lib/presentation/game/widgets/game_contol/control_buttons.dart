import 'package:flutter/material.dart';

import '../../../../app/keys/keys.dart';
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

  /// Bet or Raise button title
  String _raiseButtonTitle(AppLocalizations strings) {
    if (state.raiseState.raiseIsAllIn) {
      return strings.game_all;
    }

    return state.raiseState.isFirstBet ? strings.game_bet : strings.game_raise;
  }

  /// Raise button callback
  void _raiseAction() {
    if (state.raiseState.raiseIsAllIn) {
      controlAction(GameControlResult.allIn());
    }

    openRaiseField();
  }

  /// Call/Check/AlIn button title
  String _mainButtonTitle(AppLocalizations strings) => state.mainState.map(
        check: (_) => strings.game_check,
        call: (state) {
          final prefix =
              state.callIsAllIn ? strings.game_all : strings.game_call;

          return '$prefix\n${state.callValue.toSeparatedBank}';
        },
      );

  /// Call/Check/AlIn button callback
  void _mainAction() {
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
  }

  bool get _raiseButtonActive => state.raiseState.canRaise;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Raise / Bet
        if (_raiseButtonActive)
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: ControlButtonWrapper(
              key: GameControlKeys.raiseButton,
              title: _raiseButtonTitle(strings),
              color: context.theme.primaryColor,
              action: () => _raiseAction(),
            ),
          ),
        SizedBox(width: stdHorizontalOffset),
        // Call/Check/AlIn
        Flexible(
          flex: _raiseButtonActive ? 20 : 31,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            key: _raiseButtonActive
                ? GameControlKeys.callButton
                : GameControlKeys.allInButton,
            title: _mainButtonTitle(strings),
            color: context.theme.secondaryColor,
            action: () => _mainAction(),
          ),
        ),
        // Fold
        SizedBox(width: stdHorizontalOffset),
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            key: GameControlKeys.foldButton,
            title: context.strings.game_fold,
            color: context.theme.additionButtonColor,
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
  Widget build(BuildContext context) => MyButton(
        height: stdButtonHeight,
        width: double.infinity,
        buttonColor: color,
        textString: title,
        action: () => action(),
      );
}
