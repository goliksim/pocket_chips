import 'package:flutter/material.dart';

import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';

class ChipsImage extends StatelessWidget {
  const ChipsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.all(stdHorizontalOffset),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              context.theme.bgrColor.withAlpha(250),
              BlendMode.dstIn,
            ),
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            image: AssetsProvider.mainChipsLogo,
          ),
        ),
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
      );
}
