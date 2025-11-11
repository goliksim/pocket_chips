import 'package:flutter/material.dart';

import '../../../../../utils/extensions.dart';
import '../../../../../utils/theme/ui_values.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 123 / 176,
        child: Container(
          key: const Key('1'),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: context.theme.bankColor.withAlpha(255),
            ),
            borderRadius: BorderRadius.circular(0.5 * stdBorderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.4 * stdBorderRadius),
            child: child,
          ),
        ),
      );
}
