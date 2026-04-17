import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../services/assets_provider.dart';
import '../../../../../../utils/extensions.dart';
import '../../../../../../utils/theme/ui_values.dart';
import '../card_widget.dart';

class CardFrontSample extends StatelessWidget {
  const CardFrontSample({super.key});

  @override
  Widget build(BuildContext context) => CardWidget(
        borderColor: (context.theme.name == 'dark')
            ? context.theme.playerColor
            : context.theme.bankColor,
        child: ColoredBox(
          color: (context.theme.name == 'dark')
              ? context.theme.bankColor
              : context.theme.playerColor,
          child: Image(
            fit: BoxFit.cover,
            image: AssetsProvider.cardFront(context.theme.isDark),
            errorBuilder: (context, error, stackTrace) => Icon(
              MdiIcons.heart,
              size: stdIconSize,
              color: context.theme.alertColor,
            ),
          ),
        ),
      );
}
