import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/extensions.dart';
import '../../../../../utils/theme/ui_values.dart';
import '../control_buttons.dart';
import '../view_state/game_control_result.dart';
import '../view_state/game_page_control_state.dart';
import 'raise_provider.dart';

class RaiseButtons extends StatelessWidget {
  final RaiseControlState state;
  final void Function(GameControlRaiseResult) onConfirm;
  final VoidCallback onClose;

  const RaiseButtons({
    required this.state,
    required this.onConfirm,
    required this.onClose,
    super.key,
  });

  //Текст кнопки подтверждения
  String raiseBetString({required AppLocalizations strings, required int bet}) {
    if (bet == state.maxPossibleBet) {
      // ALL IN
      return strings.game_all;
    } else {
      return state.isFirstBet
          ? '${strings.game_bet} \$$bet'
          : '${strings.game_raise} \$$bet';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBet = CurrentBetValueProvider.of(context).currentBet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Кнопка Cancel
        Flexible(
          flex: 100,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: context.strings.game_raise_canc,
            color: thisTheme.subsubmainColor,
            action: () => onClose(),
          ),
        ),
        SizedBox(width: stdHorizontalOffset),
        // Кнопка подтверждения Raise/Bet
        Flexible(
          flex: 209,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: raiseBetString(strings: context.strings, bet: currentBet),
            color: thisTheme.secondaryColor,
            action: () => onConfirm(
              GameControlRaiseResult(raiseValue: currentBet),
            ),
          ),
        ),
      ],
    );
  }
}
