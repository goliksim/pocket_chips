import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../app/keys/keys.dart';
import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import '../onboarding_dialog.dart';

class OnboardingLinksPage extends StatelessWidget {
  final void Function(String) launchUrl;
  final VoidCallback sendMail;
  final VoidCallback showUpdateInfo;

  final String? version;

  const OnboardingLinksPage({
    required this.launchUrl,
    required this.sendMail,
    required this.showUpdateInfo,
    this.version,
    super.key,
  });

  bool get canSendMail => !kIsWeb && Platform.isAndroid;

  //TODO Remote config
  String get _appId =>
      Platform.isAndroid ? 'com.goliksim.pocketchips' : 'YOUR_IOS_APP_ID';
  String get _appUrl => Platform.isAndroid
      ? 'https://play.google.com/store/apps/details?id=$_appId'
      : 'https://apps.apple.com/app/id$_appId';
  String get _policyUrl =>
      'https://github.com/goliksim/pocket_chips/blob/main/privacy_policy.md';
  String get _gitUrl => 'https://github.com/goliksim';
  String get _telegramUrl => 'https://t.me/goliksim';

  @override
  Widget build(BuildContext context) => OnboardingPage(
        title: context.strings.about_link_1,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              context.strings.about_link_2,
              style: TextStyle(
                height: 1.5,
                color: context.theme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: stdFontSize * 0.7,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: stdHorizontalOffset / 1.5),
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) ...[
            MyButton(
              height: stdButtonHeight * 0.5,
              width: stdButtonHeight * 2,
              side: BorderSide(width: 1, color: context.theme.primaryColor),
              buttonColor: context.theme.playerColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: stdHorizontalOffset,
                        ),
                        child: Text(
                          context.strings.about_link_3,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Icon(
                      MdiIcons.star,
                      size: stdIconSize,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
              action: () async => launchUrl(_appUrl),
            ),
            SizedBox(height: stdHorizontalOffset / 2),
          ],
          Text(
            '${context.strings.about_link_4}\n\n${context.strings.about_link_5}',
            style: TextStyle(
              height: 1.5,
              color: context.theme.onBackground,
              fontWeight: FontWeight.w500,
              fontSize: stdFontSize * 0.7,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: stdHorizontalOffset / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyButton(
                height: stdButtonHeight / 2,
                width: stdButtonHeight / 2,
                buttonColor: context.theme.bgrColor,
                child: AssetsProvider.socialTelegramIcon,
                action: () => launchUrl(_telegramUrl),
              ),
              MyButton(
                height: stdButtonHeight / 2,
                width: stdButtonHeight / 2,
                buttonColor: context.theme.bgrColor,
                child: AssetsProvider.socialGitIcon,
                action: () => launchUrl(_gitUrl),
              ),
              if (canSendMail)
                MyButton(
                  height: stdButtonHeight / 2,
                  width: stdButtonHeight / 2,
                  buttonColor: context.theme.bgrColor,
                  child: AssetsProvider.socialMailIcon,
                  action: () async => sendMail(),
                ),
            ],
          ),
          SizedBox(height: stdHorizontalOffset),
          SizedBox(
            width: double.infinity,
            child: Text(
              '© 2025 GOLIKSIM (Alexander Golev)',
              style: TextStyle(
                height: 1.5,
                color: context.theme.onBackground,
                fontWeight: FontWeight.w500,
                fontSize: stdFontSize * 0.7,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if (version != null)
            MyButton(
              key: OnboardingKeys.showUpdateDialogButton,
              height: stdButtonHeight * 0.5,
              borderRadius: BorderRadius.circular(stdBorderRadius / 3),
              alignment: Alignment.centerLeft,
              buttonColor: context.theme.playerColor,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Version: $version',
                  style: TextStyle(
                    height: 1.5,
                    color: context.theme.secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              action: () async {
                showUpdateInfo();
              },
            ),
          SizedBox(
            height: stdHorizontalOffset / 2,
          ),
          MyButton(
            height: stdButtonHeight * 0.5,
            borderRadius: BorderRadius.circular(stdBorderRadius / 3),
            alignment: Alignment.centerLeft,
            buttonColor: context.theme.playerColor,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                context.strings.about_link_7,
                style: TextStyle(
                  color: context.theme.secondaryColor,
                  fontSize: stdFontSize * 0.7,
                ),
              ),
            ),
            action: () => launchUrl(_policyUrl),
          ),
        ],
      );
}
