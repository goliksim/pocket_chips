import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';

class ChipsImage extends StatelessWidget {
  const ChipsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: EdgeInsets.all(stdHorizontalOffset),
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              context.theme.bgrColor.withAlpha(250),
              BlendMode.dstIn,
            ),
            child: Image(
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              image: AssetsProvider.mainChipsLogo,
              errorBuilder: (_, __, ___) => Icon(
                size: MediaQuery.of(context).size.width * 0.75,
                color: context.theme.primaryColor,
                MdiIcons.cards,
              ),
            ),
          ),
        ),
      );
}
