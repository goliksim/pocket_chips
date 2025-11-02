import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../utils/theme/ui_values.dart';
import '../card_widget.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: ColorFiltered(
        colorFilter: (thisTheme.name == 'dark')
            ? ColorFilter.mode(
                thisTheme.primaryColor.withAlpha(50),
                BlendMode.srcATop,
              )
            : ColorFilter.mode(
                thisTheme.primaryColor.withAlpha(205),
                BlendMode.colorDodge,
              ),
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(
            (thisTheme.name == 'dark')
                ? 'assets/сard_back_dark.jpg'
                : 'assets/сard_back.jpg',
          ),
        ),
      ),
    );
  }
}
