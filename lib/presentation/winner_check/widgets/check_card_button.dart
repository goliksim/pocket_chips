import 'package:flutter/material.dart';

import '../../../domain/models/cards/card_model.dart' as c;
import '../../../utils/theme/ui_values.dart';
import 'check_card_picker.dart';

class CardButton extends StatelessWidget {
  const CardButton({super.key, required this.child, required this.action});
  final Widget child;
  final void Function(c.Card?) action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        elevation: stdElevation,
        foregroundColor: thisTheme.bgrColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: child,
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CardPicker(
              action: action,
            );
          },
        );
      },
      onLongPress: () {
        action(null);
      },
    );
  }
}
