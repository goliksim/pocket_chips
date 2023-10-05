import 'package:flutter/material.dart';
import 'package:pocket_chips/data/uiValues.dart';

import '../card_widget.dart';

Widget get cardBack => CardWidget(
      child: ColorFiltered(
        colorFilter: (thisTheme.name == 'dark')
            ? ColorFilter.mode(
                thisTheme.primaryColor.withOpacity(0.2),
                BlendMode.srcATop,
              )
            : ColorFilter.mode(
                thisTheme.primaryColor.withOpacity(0.8),
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
