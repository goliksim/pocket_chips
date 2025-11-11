import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import '../onboarding_dialog.dart';

class OnboardingWelcomePage extends StatelessWidget {
  final String title;
  final void Function(Locale) setLocale;

  const OnboardingWelcomePage({
    required this.setLocale,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: title,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              '${context.strings.about_welc_1}\n\n${context.strings.about_welc_2}',
              style: TextStyle(
                height: 1.5,
                color: context.theme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: stdFontSize * 0.7,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: stdHorizontalOffset / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                MdiIcons.accountGroup,
                color: context.theme.onBackground,
                size: stdIconSize,
              ),
              Icon(
                MdiIcons.cards,
                color: context.theme.onBackground,
                size: stdIconSize,
              ),
              Icon(
                MdiIcons.cellphone,
                color: context.theme.onBackground,
                size: stdIconSize,
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset),
          SizedBox(
            width: double.infinity,
            child: Text(
              '${context.strings.about_welc_3}\n- ${context.strings.about_welc_4}\n- ${context.strings.about_welc_5}\n- ${context.strings.about_welc_6}',
              style: TextStyle(
                height: 1.5,
                color: context.theme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: stdFontSize * 0.7,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: stdHorizontalOffset * 2),
          SizedBox(
            width: double.infinity,
            child: Text(
              context.strings.about_welc_7,
              style: TextStyle(
                height: 1.5,
                color: context.theme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: stdFontSize * 0.7,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: stdHorizontalOffset),
          Row(
            children: [
              Text(
                'Languages:',
                style: TextStyle(
                  height: 1.5,
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: SizedBox(width: stdHorizontalOffset),
              ),
              MyButton(
                height: stdButtonHeight * 0.75,
                width: stdButtonHeight * 0.75,
                buttonColor: context.theme.bankColor,
                textString: 'En',
                action: () => setLocale(
                  Locale.fromSubtags(
                    languageCode: 'en',
                  ),
                ),
              ),
              SizedBox(width: stdHorizontalOffset),
              MyButton(
                height: stdButtonHeight * 0.75,
                width: stdButtonHeight * 0.75,
                buttonColor: context.theme.bankColor,
                textString: 'Ru',
                action: () => setLocale(
                  Locale.fromSubtags(
                    languageCode: 'ru',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset),
        ],
      );
}
