import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../services/assets_provider.dart';
import '../../../../../../utils/extensions.dart';
import '../card_widget.dart';

class CardFrontSample extends StatelessWidget {
  const CardFrontSample({super.key});

  @override
  Widget build(BuildContext context) => CardWidget(
        child: ColoredBox(
          color: (context.theme.name == 'dark')
              ? context.theme.bankColor
              : context.theme.playerColor,
          child: Image(
            fit: BoxFit.cover,
            image: AssetsProvider.cardFront(context.theme.isDark),
          ),
        ),
      );
}
