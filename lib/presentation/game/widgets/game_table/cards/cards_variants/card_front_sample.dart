import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../services/assets_provider.dart';
import '../../../../../../utils/theme/themes.dart';
import '../../../../../../utils/theme/ui_values.dart';
import '../card_widget.dart';

class CardFrontSample extends StatelessWidget {
  const CardFrontSample({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: ColoredBox(
        color: (thisTheme.name == 'dark')
            ? thisTheme.bankColor
            : thisTheme.playerColor,
        child: Image(
          fit: BoxFit.cover,
          image: AssetsProvider.cardFront(thisTheme.isDark),
        ),
      ),
    );
  }
}
