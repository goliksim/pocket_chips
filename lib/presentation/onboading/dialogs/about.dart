// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:onboarding/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../di/view_models.dart';
import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';
import '../../lobby/player_list/view_state/lobby_player_item.dart';
import '../../lobby/player_list/widgets/player_card.dart';
import '../onboarding_dialog.dart';

class AboutDialog extends StatefulWidget {
  const AboutDialog({
    super.key,
  });

  @override
  State<AboutDialog> createState() => _AboutDialogState();
}

class _AboutDialogState extends State<AboutDialog> {
  LobbyPlayerItem tutorPlayer = LobbyPlayerItem(
    name: 'TestPlayer',
    assetUrl: 'assets/faces/pokerfaces0.jpg',
    bank: 500,
    uid: Uuid().v4(),
  );
  int tmpBid = 0;

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (context, ref, _) {
          ref.watch(onboardingViewModelProvider);

          final viewModel = ref.watch(onboardingViewModelProvider.notifier);
          final state = ref.watch(onboardingViewModelProvider);

          final title = state.maybeWhen(
            data: (data) => data.isFirstLaunch
                ? '${context.strings.about_welc}\nPOCKET CHIPS'
                : 'POCKET CHIPS',
            orElse: () => '',
          );

          final version = state.maybeWhen(
            data: (data) => data.version,
            orElse: () => null,
          );

          return OnboardingDialog(
            onComplete: () => viewModel.onComplete(),
            pages: [
              // first page
              PageModel(
                widget: OnboardingPage(
                  title: title,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        '${context.strings.about_welc_1}\n\n${context.strings.about_welc_2}',
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
                        '${context.strings.about_welc_3}\n- ${context.strings.about_welc_4}\n- ${context.strings.about_welc_5}\n- ${context.strings.about_welc_6}',
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
                        context.strings.about_welc_7,
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
                          textString: 'En',
                          action: () => viewModel.setLocale(
                            Locale.fromSubtags(
                              languageCode: 'en',
                            ),
                          ),
                        ),
                        SizedBox(width: stdHorizontalOffset),
                        MyButton(
                          height: stdButtonHeight * 0.75,
                          width: stdButtonHeight * 0.75,
                          buttonColor: thisTheme.bankColor,
                          textString: 'Ru',
                          action: () => viewModel.setLocale(
                            Locale.fromSubtags(
                              languageCode: 'ru',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: stdHorizontalOffset),
                  ],
                ),
              ),
              // homescreen
              PageModel(
                widget: OnboardingPage(
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
                            tooltip: context.strings.tooltip_theme,
                            onPressed: () async => viewModel.changeTheme(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: stdHorizontalOffset / 2),
                    Text(
                      '${context.strings.about_hom_3}\n\n${context.strings.about_hom_4}',
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
                  title: context.strings.about_plme_1,
                  children: [
                    Text(
                      context.strings.about_plme_2,
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
                        child: PlayerCard(
                          player: tutorPlayer,
                          canReorderOrDismiss: false,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: stdHorizontalOffset / 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '- ${context.strings.about_plme_3}',
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
                            '- ${context.strings.about_plme_4}\n${context.strings.about_plme_5}',
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
                        '\n- ${context.strings.about_plme_6}\n\n- ${context.strings.about_plme_7}\n',
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
                        ),
                      ],
                    ),
                    Text(
                      '${context.strings.about_set_3}\n- ${context.strings.about_set_4}\n- ${context.strings.about_set_5}\n- ${context.strings.about_set_6}\n\n${context.strings.about_set_7}\n- ${context.strings.about_set_8}\n- ${context.strings.about_set_9}',
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
                        ),
                      ],
                    ),
                    Text(
                      context.strings.about_tab_3,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      for (int a in [
                                        1,
                                        5,
                                        10,
                                        25,
                                        50,
                                        100,
                                        500,
                                        1000,
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
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                      '\n${context.strings.about_tab_4}\n\t\t${context.strings.about_tab_5}',
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
                  title: context.strings.about_link_1,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        context.strings.about_link_2,
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
                                  context.strings.about_link_3,
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
                          ),
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
                      '${context.strings.about_link_4}\n\n${context.strings.about_link_5}',
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
                            const url = 'https://t.me/goliksim';
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
                        if (viewModel.canSendMail)
                          MyButton(
                            height: stdButtonHeight / 2,
                            width: stdButtonHeight / 2,
                            buttonColor: thisTheme.bgrColor,
                            child: Image.asset('assets/social/mail.png'),
                            action: () async => viewModel.sendMail(),
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
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: stdFontSize * 0.7,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (version != null)
                      MyButton(
                        height: stdButtonHeight * 0.5,
                        borderRadius:
                            BorderRadius.circular(stdBorderRadius / 3),
                        alignment: Alignment.centerLeft,
                        //side: BorderSide(width: 1, color: thisTheme.primaryColor),
                        buttonColor: thisTheme.playerColor,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Version: $version',
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
                          viewModel.showUpdateInfo();
                        },
                      ),
                    SizedBox(
                      height: stdHorizontalOffset / 2,
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
                          ' ${context.strings.about_link_7}',
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
        },
      );
}
