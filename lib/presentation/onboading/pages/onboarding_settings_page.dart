import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../onboarding_dialog.dart';

class OnboardingSettingsPage extends StatelessWidget {
  const OnboardingSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: context.strings.about_set_1,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  context.strings.about_set_2,
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
                child: Icon(
                  Icons.settings,
                  size: stdIconSize,
                  color: context.theme.onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset * 2),
          Text(
            '${context.strings.about_set_3}\n- ${context.strings.about_set_4}\n- ${context.strings.about_set_5}\n- ${context.strings.about_set_6}\n- ${context.strings.about_set_8}\n- ${context.strings.about_set_9}',
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
