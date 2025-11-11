import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../onboarding_dialog.dart';

class OnboardingHomePage extends StatelessWidget {
  final VoidCallback changeTheme;

  const OnboardingHomePage({
    required this.changeTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: context.strings.about_hom_1,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  context.strings.about_hom_2,
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: stdButtonHeight,
                height: stdButtonHeight,
                child: IconButton(
                  icon: Icon(
                    (context.theme.isDark)
                        ? Icons.nightlight_round
                        : Icons.mode_night_outlined,
                    size: stdIconSize,
                    color: context.theme.onBackground,
                  ),
                  tooltip: context.strings.tooltip_theme,
                  onPressed: () => changeTheme(),
                ),
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset * 2),
          Text(
            '${context.strings.about_hom_3}\n\n${context.strings.about_hom_4}',
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      );
}
