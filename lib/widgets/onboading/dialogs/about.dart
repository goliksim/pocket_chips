// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:onboarding/onboarding.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pocket_chips/data/config_model.dart';
import 'package:pocket_chips/data/lobby.dart';
import 'package:pocket_chips/data/storage.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/internal/application.dart';
import 'package:pocket_chips/internal/localization.dart';
import 'package:pocket_chips/pages/playersPage.dart';
import 'package:pocket_chips/ui/transitions.dart';
import 'package:pocket_chips/ui/ui_widgets.dart';
import 'package:pocket_chips/widgets/onboading/dialogs/update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../onboarding.dart';

Future showHelp(BuildContext context, callBack, {onWillpop = false}) async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  // ignore: use_build_context_synchronously
  transitionDialog(
    duration: const Duration(milliseconds: 400),
    type: 'Scale',
    context: context,
    child: WillPopScope(
      onWillPop: () async => onWillpop,
      child: AboutDialog(
        callbackFunction: callBack,
        packageInfo: packageInfo,
        isFirst: !onWillpop,
      ),
    ),
    builder: (BuildContext context) {
      return AboutDialog(
        callbackFunction: callBack,
        packageInfo: packageInfo,
        isFirst: !onWillpop,
      );
    },
  );
}

class AboutDialog extends StatefulWidget {
  const AboutDialog({
    Key? key,
    required this.callbackFunction,
    required this.packageInfo,
    required this.isFirst,
  }) : super(key: key);

  final Function() callbackFunction;
  final PackageInfo packageInfo;
  final bool isFirst;
  @override
  State<AboutDialog> createState() => _AboutDialogState();
}

class _AboutDialogState extends State<AboutDialog> {
  Player tutorPlayer =
      Player('TestPlayer', 'assets/faces/pokerfaces0.jpg', 500);
  int tmpBid = 0;

  @override
  Widget build(BuildContext context) {
    return OnboardingDialog(
      callbackFunction: widget.callbackFunction,
      packageInfo: widget.packageInfo,
      pages: [
        // first page
        PageModel(
          widget: OnboardingPage(
            title: widget.isFirst
                ? '${context.locale.about_welc}\nPOCKET CHIPS'
                : 'POCKET CHIPS',
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  '${context.locale.about_welc_1}\n\n${context.locale.about_welc_2}',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
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
                    color: thisTheme.onBackground.withOpacity(1),
                    size: stdIconSize,
                  ),
                  Icon(
                    MdiIcons.cards,
                    color: thisTheme.onBackground.withOpacity(1),
                    size: stdIconSize,
                  ),
                  Icon(
                    MdiIcons.cellphone,
                    color: thisTheme.onBackground.withOpacity(1),
                    size: stdIconSize,
                  ),
                ],
              ),
              SizedBox(height: stdHorizontalOffset),
              SizedBox(
                width: double.infinity,
                child: Text(
                  '${context.locale.about_welc_3}\n- ${context.locale.about_welc_4}\n- ${context.locale.about_welc_5}\n- ${context.locale.about_welc_6}',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
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
                  context.locale.about_welc_7,
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
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
                      color: thisTheme.onBackground,
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
                    buttonColor: thisTheme.bankColor,
                    textString: '1',
                    action: () {
                      MyApp.of(context).setLocale(
                        const Locale.fromSubtags(
                          languageCode: 'en',
                        ),
                        context,
                      );
                      thisConfig.locale = 'en';
                      configStorage.write(thisConfig);
                      widget.callbackFunction();
                    },
                  ),
                  SizedBox(width: stdHorizontalOffset),
                  MyButton(
                    height: stdButtonHeight * 0.75,
                    width: stdButtonHeight * 0.75,
                    buttonColor: thisTheme.bankColor,
                    textString: '2',
                    action: () {
                      MyApp.of(context).setLocale(
                        const Locale.fromSubtags(
                          languageCode: 'ru',
                        ),
                        context,
                      );
                      thisConfig.locale = 'ru';
                      configStorage.write(thisConfig);
                      widget.callbackFunction();
                    },
                  )
                ],
              ),
              SizedBox(height: stdHorizontalOffset),
            ],
          ),
        ),
        // homescreen
        PageModel(
          widget: OnboardingPage(
            title: context.locale.about_hom_1,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      context.locale.about_hom_2,
                      style: TextStyle(
                        height: 1.5,
                        color: thisTheme.onBackground,
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
                        (thisTheme == themeList[0])
                            ? Icons.mode_night_outlined
                            : Icons.nightlight_round,
                        size: stdIconSize,
                        color: thisTheme.onBackground,
                      ),
                      tooltip: context.locale.tooltip_theme,
                      onPressed: () async {
                        changeTheme();
                        widget.callbackFunction();
                        setState(() {});

                        //setState({});
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: stdHorizontalOffset / 2),
              Text(
                '${context.locale.about_hom_3}\n\n${context.locale.about_hom_4}',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        // Player Menu
        PageModel(
          widget: OnboardingPage(
            title: context.locale.about_plme_1,
            children: [
              Text(
                context.locale.about_plme_2,
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: stdHorizontalOffset),
              ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(stdBorderRadius)),
                child: Dismissible(
                  confirmDismiss: (direction) async {
                    DoNothingAction();
                    return null;
                  },
                  key: const Key('0'),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {},
                  background: Container(
                    color: thisTheme.bgrColor,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Icon(
                            Icons.add,
                            color: thisTheme.onBackground,
                            size: stdIconSize,
                          ),
                        ),
                        Text(
                          ' ' 'Save Player',
                          style: TextStyle(
                            color: thisTheme.onBackground,
                            fontSize: stdFontSize * 0.75,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: thisTheme.bgrColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Delete Player',
                          style: TextStyle(
                            color: thisTheme.subsubmainColor,
                            fontSize: stdFontSize * 0.75,
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Icon(
                            Icons.delete,
                            color: thisTheme.subsubmainColor,
                            size: stdIconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: playerCard(
                    tutorPlayer,
                    null,
                    stdButtonHeight * 0.85,
                    false,
                    context,
                    () => setState(() {}),
                  ),
                ),
              ),
              SizedBox(
                height: stdHorizontalOffset / 2,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '- ${context.locale.about_plme_3}',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '- ${context.locale.about_plme_4}\n${context.locale.about_plme_5}',
                      style: TextStyle(
                        height: 1.5,
                        color: thisTheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: stdFontSize * 0.7,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: stdButtonHeight * 0.8,
                    height: stdButtonHeight * 0.6,
                    child: Icon(
                      Icons.folder_shared,
                      size: stdIconSize,
                      color: thisTheme.onBackground,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '\n- ${context.locale.about_plme_6}\n\n- ${context.locale.about_plme_7}\n',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        // Settings
        PageModel(
          widget: OnboardingPage(
            title: context.locale.about_set_1,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      context.locale.about_set_2,
                      style: TextStyle(
                        height: 1.5,
                        color: thisTheme.onBackground,
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
                      color: thisTheme.onBackground,
                    ),
                  )
                ],
              ),
              Text(
                '${context.locale.about_set_3}\n- ${context.locale.about_set_4}\n- ${context.locale.about_set_5}\n- ${context.locale.about_set_6}\n\n${context.locale.about_set_7}\n- ${context.locale.about_set_8}\n- ${context.locale.about_set_9}',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        // Game table
        PageModel(
          widget: OnboardingPage(
            title: context.locale.about_tab_1,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      context.locale.about_tab_2,
                      style: TextStyle(
                        height: 1.5,
                        color: thisTheme.onBackground,
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
                      color: thisTheme.onBackground,
                    ),
                  )
                ],
              ),
              Text(
                context.locale.about_tab_3,
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(stdBorderRadius),
                child: Container(
                  color: thisTheme.playerColor,
                  child: Column(
                    children: [
                      SizedBox(
                        height: stdHorizontalOffset / 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: stdHorizontalOffset / 2,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            stdButtonHeight * 0.75,
                          ),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (int a in [
                                  1,
                                  5,
                                  10,
                                  25,
                                  50,
                                  100,
                                  500,
                                  1000
                                ])
                                  Container(
                                    width: stdButtonHeight * 0.6,
                                    height: stdButtonHeight * 0.6,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: thisTheme.playerColor,
                                      borderRadius: BorderRadius.circular(
                                        stdBorderRadius,
                                      ),
                                    ),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.all(4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            stdBorderRadius,
                                          ),
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/chips/chips_$a.png',
                                      ),
                                      onPressed: () {
                                        if (tmpBid + a <= 5000) {
                                          tmpBid += a;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: stdHorizontalOffset,
                        ),
                        height: stdButtonHeight * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: stdFontSize,
                                color: thisTheme.onBackground,
                              ),
                            ),
                            SizedBox(width: stdHorizontalOffset / 2),
                            Flexible(
                              flex: 6,
                              fit: FlexFit.tight,
                              child: Slider(
                                label: '$tmpBid',
                                value: tmpBid.toDouble(),
                                onChanged: (newValue) {
                                  //thisLobby.lobbyPlayers[thisLobby.lobbyIndex].bank+=thisLobby.bids[thisLobby.lobbyIndex];
                                  tmpBid = newValue.toInt();

                                  setState(() {});
                                },
                                min: 0,
                                max: 5000,
                              ),
                            ),
                            SizedBox(width: stdHorizontalOffset / 2),
                            Container(
                              alignment: Alignment.center,
                              width: stdButtonHeight / 1.5,
                              child: Text(
                                '$tmpBid',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: stdFontSize,
                                  color: thisTheme.onBackground,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '\n${context.locale.about_tab_4}\n\t\t${context.locale.about_tab_5}',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: stdFontSize * 0.7,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        // Helpful
        PageModel(
          widget: OnboardingPage(
            title: context.locale.about_link_1,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  context.locale.about_link_2,
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: stdHorizontalOffset / 1.5),
              MyButton(
                height: stdButtonHeight * 0.5,
                width: stdButtonHeight * 2,
                side: BorderSide(width: 1, color: thisTheme.primaryColor),
                buttonColor: thisTheme.playerColor,
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
                            context.locale.about_link_3,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: thisTheme.primaryColor,
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
                        color: thisTheme.primaryColor,
                      ),
                    )
                  ],
                ),
                action: () async {
                  if (!kIsWeb) {
                    if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid
                          ? 'com.goliksim.pocketchips'
                          : 'YOUR_IOS_APP_ID';
                      final url = Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=$appId'
                          : 'https://apps.apple.com/app/id$appId';
                      launch(
                        url,
                      );
                    }
                  }
                },
              ),
              SizedBox(height: stdHorizontalOffset / 2),
              Text(
                '${context.locale.about_link_4}\n\n${context.locale.about_link_5}',
                style: TextStyle(
                  height: 1.5,
                  color: thisTheme.onBackground,
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
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/tele.png'),
                    action: () async {
                      const url = 'https://t.me/huzhetebyx';
                      if (!await launch(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  MyButton(
                    height: stdButtonHeight / 2,
                    width: stdButtonHeight / 2,
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/git.png'),
                    action: () async {
                      const url = 'https://github.com/goliksim';
                      if (!await launch(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                  MyButton(
                    height: stdButtonHeight / 2,
                    width: stdButtonHeight / 2,
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/mail.png'),
                    action: () async {
                      final path = await localPath;
                      final MailOptions mailOptions = MailOptions(
                        body: LocaleManager.locale.about_link_6,
                        subject: 'PC: problem or advice ',
                        recipients: ['goliksim@gmail.com'],
                        isHTML: true,
                        attachments: [
                          '$path/pocketchips/poker_chips.log',
                        ],
                      );
                      await FlutterMailer.send(mailOptions);
                    },
                  ),
                ],
              ),
              SizedBox(height: stdHorizontalOffset),
              SizedBox(
                width: double.infinity,
                child: Text(
                  '© 2022 GOLIKSIM (Alexander Golev)',
                  style: TextStyle(
                    height: 1.5,
                    color: thisTheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: stdFontSize * 0.7,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              MyButton(
                height: stdButtonHeight * 0.5,
                borderRadius: BorderRadius.circular(stdBorderRadius / 3),
                alignment: Alignment.centerLeft,
                //side: BorderSide(width: 1, color: thisTheme.primaryColor),
                buttonColor: thisTheme.playerColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Version: ${widget.packageInfo.version}',
                    style: TextStyle(
                      height: 1.5,
                      color: thisTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: stdFontSize * 0.7,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                action: () async {
                  showUpdate(context);
                },
              ),
              MyButton(
                height: stdButtonHeight * 0.5,
                borderRadius: BorderRadius.circular(stdBorderRadius / 3),
                alignment: Alignment.centerLeft,
                //side: BorderSide(width: 1, color: thisTheme.primaryColor),
                buttonColor: thisTheme.playerColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    ' ${context.locale.about_link_7}',
                    style: TextStyle(
                      color: thisTheme.secondaryColor,
                      fontSize: stdFontSize * 0.7,
                    ),
                  ),
                ),
                action: () async {
                  const url =
                      'https://github.com/goliksim/pocket_chips/blob/main/privacy_policy.md';
                  if (!await launch(url)) throw 'Could not launch $url';
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
