import 'package:flutter/material.dart';

import '../../../../../data/uiValues.dart';
import '../card_widget.dart';

Widget get cardBack => CardWidget(
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
