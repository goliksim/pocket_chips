import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/attention_button.dart';

class AttentionAddPlayerButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool Function() needToAnimate;

  const AttentionAddPlayerButton({
    required this.onTap,
    required this.needToAnimate,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AttentionButton(
        bgColor: context.theme.playerColor,
        textColor: context.theme.primaryColor,
        onTap: () => onTap(),
        needToAnimate: needToAnimate,
        textWidget: needToAnimate()
            ? Text(
                context.strings.playp_add,
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontSize: stdFontSize * 0.75,
                ),
              )
            : Icon(
                Icons.add_sharp,
                color: context.theme.primaryColor,
                size: stdIconSize,
              ),
      );
}
