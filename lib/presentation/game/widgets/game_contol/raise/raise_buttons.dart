import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../utils/extensions.dart';
import '../../../../../utils/theme/ui_values.dart';
import '../control_buttons.dart';
import '../view_state/game_control_result.dart';
import '../view_state/game_page_control_state.dart';
import 'raise_provider.dart';

class RaiseButtons extends StatefulWidget {
  final RaiseControlState state;
  final void Function(GameControlRaiseResult) onConfirm;
  final VoidCallback onClose;

  const RaiseButtons({
    required this.state,
    required this.onConfirm,
    required this.onClose,
    super.key,
  });

  @override
  State<RaiseButtons> createState() => _RaiseButtonsState();
}

class _RaiseButtonsState extends State<RaiseButtons> {
  /// Raise/Bet confirmation text
  String _raiseBetConfirmationText({
    required AppLocalizations strings,
    required int additionalBet,
    required int currentBet,
  }) {
    final totalBet = additionalBet + currentBet;
    var valueString = totalBet.toSeparatedBank;

    if (kDebugMode) {
      valueString += " / ${additionalBet.toSeparatedBank} additional";
    }

    if (additionalBet == widget.state.maxPossibleBet) {
      // ALL IN
      return '${strings.game_all}\n$valueString';
    } else {
      return widget.state.isFirstBet
          ? '${strings.game_bet_to}\n$valueString'
          : '${strings.game_raise_to}\n$valueString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final additionalBet = NewBetValueProvider.of(context).additionalBet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Raise Cancel
        Flexible(
          flex: 10,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: context.strings.game_raise_canc,
            color: context.theme.alertColor,
            action: () => widget.onClose(),
          ),
        ),
        SizedBox(width: stdHorizontalOffset),
        // Confirm Raise/Bet
        Flexible(
          flex: 31,
          fit: FlexFit.tight,
          child: ControlButtonWrapper(
            title: _raiseBetConfirmationText(
              strings: context.strings,
              additionalBet: additionalBet,
              currentBet: widget.state.currentBet,
            ),
            color: context.theme.secondaryColor,
            action: () => widget.onConfirm(
              GameControlRaiseResult(raiseValue: additionalBet),
            ),
          ),
        ),
      ],
    );
  }
}
