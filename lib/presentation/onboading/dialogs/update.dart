import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:onboarding/onboarding.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
//import 'package:in_app_review/in_app_review.dart';

import '../onboarding_dialog.dart';
import '../onboarding_view_model.dart';

class UpdateDialog extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const UpdateDialog({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final version = viewModel.stateModel.maybeWhen(
      data: (data) => data.version,
      orElse: () => null,
    );

    return OnboardingDialog(
      onComplete: () => viewModel.onComplete(),
      pages: [
        // first page
        PageModel(
          widget: OnboardingPage(
            title: '${context.strings.update_title} $version',
            children: [
              SizedBox(height: stdHorizontalOffset),
              Text(
                '- ${context.strings.update_1}\n',
                style: TextStyle(
                  height: 1.5,
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                width: double.infinity,
                height: stdIconSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- ${context.strings.update_2}',
                      style: TextStyle(
                        height: 1.5,
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: stdFontSize * 0.7,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(width: stdHorizontalOffset / 2),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.cardsPlayingDiamondMultiple,
                            color: context.theme.onBackground,
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.cardsPlayingClubMultiple,
                            color: context.theme.onBackground,
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.arrowRight,
                            color: context.theme.onBackground,
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.crown,
                            color: context.theme.onBackground,
                            size: stdIconSize * 0.75,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${context.strings.update_3}:\n',
                style: TextStyle(
                  height: 1.5,
                  color: context.theme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.65,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(left: stdHorizontalOffset),
                child: Text(
                  '${context.strings.update_4}\n${context.strings.update_5}',
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.65,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\n- ${context.strings.update_6}',
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.65,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\n- ${context.strings.update_7}',
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.65,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
