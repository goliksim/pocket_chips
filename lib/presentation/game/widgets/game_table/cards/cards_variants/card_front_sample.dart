import 'package:flutter/material.dart';

import '../../../../../../utils/theme/ui_values.dart';
import '../card_widget.dart';

Widget get cardSample => CardWidget(
      child: ColoredBox(
        color: (thisTheme.name == 'dark')
            ? thisTheme.bankColor
            : thisTheme.playerColor,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(
            (thisTheme.name == 'dark')
                ? 'assets/card_front_dark.png'
                : 'assets/card_front.png',
          ),
        ),
      ),
    );
