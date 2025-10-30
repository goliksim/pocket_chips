import 'package:flutter/material.dart';

import '../../../utils/theme/ui_values.dart';

class ChipsImage extends StatelessWidget {
  const ChipsImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(stdHorizontalOffset),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            thisTheme.bgrColor.withAlpha(250),
            BlendMode.dstIn,
          ),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          image: const AssetImage(
            'assets/init_logo.png',
          ),
        ),
      ),
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
    );
  }
}
