import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../game/widgets/game_contol/raise/raise_field.dart';
import '../../game/widgets/game_contol/raise/raise_provider.dart';
import '../onboarding_dialog.dart';

class OnboardingGamePage extends StatelessWidget {
  const OnboardingGamePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: context.strings.about_tab_1,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  context.strings.about_tab_2,
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
                width: stdButtonHeight * 0.8,
                height: stdButtonHeight * 0.8,
                child: Icon(
                  Icons.sync_sharp,
                  size: stdIconSize,
                  color: context.theme.onBackground,
                ),
              ),
            ],
          ),
          Text(
            context.strings.about_tab_3,
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: stdHorizontalOffset),
          RaiseProviderScope(
            currentBet: 0,
            child: Builder(
              builder: (context) => RaiseFieldWidget(
                maxPossibleBet: 500,
                minPossibleBet: 0,
              ),
            ),
          ),
          Text(
            '${context.strings.about_tab_4}\n\n${context.strings.about_tab_5}',
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
