import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../services/assets_provider.dart';
import '../../../../../../utils/extensions.dart';
import '../card_widget.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) => CardWidget(
        child: ColorFiltered(
          colorFilter: (context.theme.name == 'dark')
              ? ColorFilter.mode(
                  context.theme.primaryColor.withAlpha(50),
                  BlendMode.srcATop,
                )
              : ColorFilter.mode(
                  context.theme.primaryColor.withAlpha(205),
                  BlendMode.colorDodge,
                ),
          child: Image(
            fit: BoxFit.cover,
            image: AssetsProvider.cardBack(context.theme.isDark),
          ),
        ),
      );
}
