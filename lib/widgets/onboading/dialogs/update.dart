// ignore_for_file: deprecated_member_use

import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:onboarding/onboarding.dart';
import 'package:pocket_chips/data/lobby.dart';

import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/internal/localization.dart';

import 'package:pocket_chips/ui/transitions.dart';

//import 'package:in_app_review/in_app_review.dart';

import '../onboarding.dart';

Future showUpdate(BuildContext context) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // ignore: use_build_context_synchronously
  transitionDialog(
    duration: const Duration(milliseconds: 400),
    type: 'Scale',
    context: context,
    child: UpdateDialog(
      packageInfo: packageInfo,
    ),
    builder: (BuildContext context) {
      return UpdateDialog(
        packageInfo: packageInfo,
      );
    },
  );
}

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({
    Key? key,
    required this.packageInfo,
  }) : super(key: key);

  final PackageInfo packageInfo;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  Player tutorPlayer =
      Player('TestPlayer', 'assets/faces/pokerfaces0.jpg', 500);
  int tmpBid = 0;

  @override
  Widget build(BuildContext context) {
    return OnboardingDialog(
      packageInfo: widget.packageInfo,
      pages: [
        // first page
        PageModel(
          widget: OnboardingPage(
            //TODO локазация
            title: '${context.locale.update_title} ${widget.packageInfo.version}',
            children: [
              SizedBox(height: stdHorizontalOffset),
              Text(
                '- ${context.locale.update_1}\n',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
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
                      '- ${context.locale.update_2}',
                      style: TextStyle(
                        height: 1.5,
                        color: thisTheme.primaryColor,
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
                            color: thisTheme.onBackground.withOpacity(1),
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.cardsPlayingClubMultiple,
                            color: thisTheme.onBackground.withOpacity(1),
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.arrowRight,
                            color: thisTheme.onBackground.withOpacity(1),
                            size: stdIconSize * 0.75,
                          ),
                          Icon(
                            MdiIcons.crown,
                            color: thisTheme.onBackground.withOpacity(1),
                            size: stdIconSize * 0.75,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${context.locale.update_3}:\n',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.65,
                ),
                textAlign: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.only(left: stdHorizontalOffset),
                child: Text(
                  '${context.locale.update_4}\n${context.locale.update_5}',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.65,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\n- ${context.locale.update_6}',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
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
