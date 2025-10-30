import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class LobbyStackButton extends StatelessWidget {
  final void Function() onTap;
  final String startingStack;

  const LobbyStackButton({
    required this.onTap,
    required this.startingStack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      side: null,
      height: stdButtonHeight,
      buttonColor: thisTheme.bankColor,
      action: () async {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${context.strings.playp_init}  ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: stdFontSize,
              color: thisTheme.onBackground,
            ),
          ),
          Text(
            startingStack,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize,
              color: thisTheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
