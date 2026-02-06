import 'package:flutter/material.dart';

import '../../../app/keys/keys.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class LobbyStackButton extends StatelessWidget {
  final void Function() onTap;
  final int startingStack;

  const LobbyStackButton({
    required this.onTap,
    required this.startingStack,
    super.key = LobbyKeys.startingStackButton,
  });

  @override
  Widget build(BuildContext context) => MyButton(
        side: null,
        height: stdButtonHeight,
        buttonColor: context.theme.bankColor,
        action: () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      '${context.strings.playp_init} ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: stdFontSize,
                        color: context.theme.onBackground,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        startingStack.toSeparatedBank,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: stdFontSize,
                          color: context.theme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: stdHorizontalOffset * 2),
              child: Icon(
                Icons.edit_note,
                color: context.theme.onBackground,
                size: stdIconSize * 0.75,
              ),
            ),
          ],
        ),
      );
}
