// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:onboarding/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
//import 'package:in_app_review/in_app_review.dart';

import '../data/storage.dart';
import '../data/lobby.dart';
import '../pages/playersPage.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.callbackFunction, this.onWillPop = false})
      : super(key: key);

  final Function() callbackFunction;
  final bool onWillPop;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Material materialButton;
  late int index;

  @override
  void initState() {
    super.initState();
    //materialButton = _skipButton();
    index = 0;
  }

  Widget _skipButton({void Function(int)? setIndex}) {
    return MyButton(
      buttonColor: thisTheme.bankColor,
      height: stdButtonHeight * 0.75,
      textString: 'about.skip'.tr(),
      textStyle:
          stdTextStyle.copyWith( fontSize: stdFontSize),
      action: () {
        if (setIndex != null) {
          index = 5;
          setIndex(index);
        }
      },
    );
  }

  Widget get _finishButton {
    return MyButton(
        buttonColor: thisTheme.primaryColor,
        height: stdButtonHeight * 0.75,
        textString: 'about.end'.tr(),
        action: () {
          thisConfig.firstTime = false;
          configStorage.writeConfig(thisConfig);
          //print(thisConfig.firstTime);
          Navigator.pop(context);
        });
  }

  Player tutorPlayer =
      Player('TestPlayer', 'assets/faces/pokerfaces0.jpg', 500);
  int tmpBid = 0;

  void callBack() {
    setState(() {});
    //print('tutor setstate');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor, //Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          vertical: stdHorizontalOffset,
          horizontal:
              adaptiveOffset), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius))),
      child: SizedBox(
        width: stdButtonWidth,
        height: 485.h,
        child: PatternContainer(
          opacity: 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: stdHorizontalOffset * 2),
              child: Onboarding(
                pages: [
                  // first page
                  page(
                      widget.onWillPop
                          ? 'about.welc'.tr()+'POCKET CHIPS'
                          : 'POCKET CHIPS',
                      [
                        
                        SizedBox(
                          width:  double.infinity,
                          child: Text(
                            'about.welc.1'.tr()+'\n\n'+'about.welc.2'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
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
                            ]),
                        SizedBox(height: stdHorizontalOffset),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'about.welc.3'.tr()+'\n- '+'about.welc.4'.tr()+'\n- '+'about.welc.5'.tr()+'\n- '+'about.welc.6'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: stdHorizontalOffset * 2),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'about.welc.7'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: stdHorizontalOffset ),
                        Row(children: [
                          Text('Languages:',
                          style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                            textAlign: TextAlign.start,
                          ),
                          Expanded(child: SizedBox(width: stdHorizontalOffset )),
                           MyButton(height: stdButtonHeight*0.75, width: stdButtonHeight*0.75, buttonColor: thisTheme.bankColor,textString: '1',
                           action: () {
                            context.setLocale(const Locale('en', 'US'));

                           }
                           ),
                           SizedBox(width: stdHorizontalOffset ),
                           MyButton(height: stdButtonHeight*0.75, width: stdButtonHeight*0.75, buttonColor: thisTheme.bankColor,textString: '2',
                           action: (){
                            context.setLocale(const Locale('ru', 'RU'));
                            callBack();
                           }
                           )
                        ],),
                        SizedBox(height: stdHorizontalOffset ),
                      ]),
                  // homescreen
                  page('about.hom.1'.tr(), [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'about.hom.2'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
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
                            tooltip: 'tooltip.theme'.tr(),
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
                      'about.hom.3'.tr()+'\n\n'+'about.hom.4'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                  // Player Menu
                  page('about.plme.1'.tr(), [
                    Text(
                      'about.plme.2'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
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
                        key: const Key("0"),
                        child: playerCard(tutorPlayer, null,
                            stdButtonHeight * 0.85, false, context, callBack),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {},
                        background: Container(
                          color: thisTheme.bgrColor,
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Icon(Icons.add,
                                    color: thisTheme.onBackground,
                                    size: stdIconSize),
                              ),
                              Text(' ''Save Player',
                                  style: TextStyle(
                                      color: thisTheme.onBackground,
                                      fontSize: stdFontSize * 0.75)),
                            ],
                          ),
                        ),
                        secondaryBackground: Container(
                          color: thisTheme.bgrColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Delete Player',
                                  style: TextStyle(
                                      color: thisTheme.subsubmainColor,
                                      fontSize: stdFontSize * 0.75)),
                              AspectRatio(
                                  aspectRatio: 1,
                                  child: Icon(Icons.delete,
                                      color: thisTheme.subsubmainColor,
                                      size: stdIconSize)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: stdHorizontalOffset / 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'about.plme.3'.tr(),
                        style: TextStyle(
                            height: 1.5,
                            color: thisTheme.onBackground,
                            fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '\t\t'+'about.plme.4'.tr()+' \n'+'about.plme.5'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: stdButtonHeight * 0.8,
                          height: stdButtonHeight * 0.6,
                          child: Icon(Icons.folder_shared,
                                size: stdIconSize,
                                color: thisTheme.onBackground),
                          ),
                        
                      ],
                    ),
                    Text(
                      '\n'+'about.plme.6'.tr()+' \n\n'+'about.plme.7'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                  // Settings
                  page('about.set.1'.tr(), [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'about.set.2'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: stdButtonHeight,
                          height: stdButtonHeight,
                          child: Icon(Icons.settings,
                                size: stdIconSize,
                                color: thisTheme.onBackground),
                        )
                      ],
                    ),
                    Text(
                      'about.set.3'.tr()+'\n- '+'about.set.4'.tr()+'\n- '+'about.set.5'.tr()+'\n- '+'about.set.6'.tr()+'\n\n'+'about.set.7'.tr()+'\n- '+'about.set.8'.tr()+'\n- '+'about.set.9'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                  // Game table
                  page('about.tab.1'.tr(), [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            'about.tab.2'.tr(),
                            style: TextStyle(
                                height: 1.5,
                                color: thisTheme.onBackground,
                                fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          width: stdButtonHeight * 0.8,
                          height: stdButtonHeight * 0.8,
                          child: Icon(Icons.sync_sharp,
                                size: stdIconSize,
                                color: thisTheme.onBackground),
                        )
                      ],
                    ),
                    Text(
                      'about.tab.3'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
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
                                  horizontal: stdHorizontalOffset / 2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    stdButtonHeight * 0.75),
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
                                        1000
                                      ])
                                        Container(
                                          width: stdButtonHeight * 0.6,
                                          height: stdButtonHeight * 0.6,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 2.5),
                                          decoration: BoxDecoration(
                                            color: thisTheme.playerColor,
                                            borderRadius: BorderRadius.circular(
                                                stdBorderRadius),
                                          ),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              stdBorderRadius))),
                                              child: Image.asset(
                                                  "assets/chips/chips_$a.png"),
                                              onPressed: () {
                                                if (tmpBid + a <= 5000) {
                                                  tmpBid += a;
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: stdHorizontalOffset),
                              height: stdButtonHeight * 0.6,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "0",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: stdFontSize,
                                        color: thisTheme.onBackground),
                                  ),
                                  SizedBox(width: stdHorizontalOffset / 2),
                                  Flexible(
                                    flex: 6,
                                    fit: FlexFit.tight,
                                    child: Slider(
                                      label: "$tmpBid",
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
                                        "$tmpBid",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: stdFontSize,
                                            color: thisTheme.onBackground),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '\n'+'about.tab.4'.tr()+'\n\t\t'+'about.tab.5'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                      textAlign: TextAlign.start,
                    ),
                  ]),
                  // Helpful
                  page('about.link.1'.tr(), [
                    SizedBox(
                      width:  double.infinity,
                      child: Text(
                        'about.link.2'.tr(),
                        style: TextStyle(
                            height: 1.5,
                            color: thisTheme.onBackground,
                            fontWeight: FontWeight.w500,
                            fontSize:  stdFontSize*0.7),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: stdHorizontalOffset/1.5),
                    MyButton(height: stdButtonHeight*0.5,
                    width:stdButtonHeight*2,
                    side: BorderSide(width: 1, color: thisTheme.primaryColor),  
                    buttonColor: thisTheme.playerColor,
                    child: Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [
                      Flexible(child: FittedBox(child: Padding(padding: EdgeInsets.symmetric(horizontal: stdHorizontalOffset) ,child: Text('about.link.3'.tr(), textAlign: TextAlign.center, style: TextStyle(color: thisTheme.primaryColor,),)))), AspectRatio(aspectRatio: 1,child: Icon(MdiIcons.star,size: stdIconSize, color: thisTheme.primaryColor))
                    ],),
                    action:()async {
                      if (Platform.isAndroid || Platform.isIOS) {
                      final appId = Platform.isAndroid ? 'com.goliksim.pocketchips' : 'YOUR_IOS_APP_ID';
                      final url = Uri.parse(
                        Platform.isAndroid
                            ? "market://details?id=$appId"
                            : "https://apps.apple.com/app/id$appId",
                      );
                      launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                    }
                    ),
                    SizedBox(height: stdHorizontalOffset/2),   
                     Text(
                      'about.link.4'.tr()+'\n\n'+'about.link.5'.tr(),
                      style: TextStyle(
                          height: 1.5,
                          color: thisTheme.onBackground,
                          fontWeight: FontWeight.w500,  
                          fontSize:  stdFontSize*0.7),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: stdHorizontalOffset/2),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      MyButton(height: stdButtonHeight/2,
                    width:stdButtonHeight/2,
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/tele.png'),
                    action:()async {
                      const url = 'https://t.me/huzhetebyx';
                      if (!await launch(url)) throw 'Could not launch $url';
                    }
                    ),
                    MyButton(height: stdButtonHeight/2,
                    width:stdButtonHeight/2,
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/git.png'),
                    action:()async {
                      const url = 'https://github.com/goliksim';
                      if (!await launch(url)) throw 'Could not launch $url';
                    }
                    ),
                    MyButton(height: stdButtonHeight/2,
                    width:stdButtonHeight/2,
                    buttonColor: thisTheme.bgrColor,
                    child: Image.asset('assets/social/mail.png'),
                    action:()async {
                      //final path = await localPath;   
                      final MailOptions mailOptions = MailOptions(
                        body: 'about.link.6'.tr(),
                        subject: 'PC: problem or advice ',
                        recipients: ['goliksim@gmail.com'],
                        isHTML: true,
                        //attachments: [ '$path/pocketchips/poker_chips.log', ],
                      );
                      await FlutterMailer.send(mailOptions);
                      
                    }
                    ),
                    ]),
                    SizedBox(height: stdHorizontalOffset),
                    SizedBox(
                      width:  double.infinity,
                      child: Text(
                        '© 2022 GOLIKSIM (Alexander Golev)\nVersion: 1.0.4',
                        style: TextStyle(
                            height: 1.5,
                            color: thisTheme.onBackground,
                            fontWeight: FontWeight.w500,
                          fontSize:  stdFontSize*0.7),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: stdHorizontalOffset/2),
                    
                    MyButton(height: stdButtonHeight*0.5,
                    borderRadius: BorderRadius.circular(stdBorderRadius/3),
                    alignment: Alignment.centerLeft,
                    //side: BorderSide(width: 1, color: thisTheme.primaryColor),  
                    buttonColor: thisTheme.playerColor,
                    child: SizedBox(width:double.infinity,
                      child: Text(' '+'about.link.7'.tr(), style: TextStyle(color: thisTheme.secondaryColor,
                          fontSize:  stdFontSize*0.7),)),
                    action:()async {
                        const url = 'https://github.com/goliksim/pocket_chips/blob/main/privacy_policy.md';
                        if (!await launch(url)) throw 'Could not launch $url';
                    }
                    ),
                  ]),
                  
                ],
                onPageChange: (int pageIndex) {
                  index = pageIndex;
                },
                startPageIndex: 0,
                footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                  return Container(
                    height: 70.h,
                    color: const Color(0x00000000), //!!!!!!!!!!!!!!
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomIndicator(
                              netDragPercent: dragDistance,
                              pagesLength: pagesLength,
                              indicator: Indicator(
                                activeIndicator: const ActiveIndicator(
                                    color: Colors.grey, borderWidth: 0.7),
                                closedIndicator: ClosedIndicator(
                                    color:
                                        thisTheme.primaryColor.withOpacity(0.5),
                                    borderWidth: 0.7),
                                indicatorDesign: IndicatorDesign.polygon(
                                  polygonDesign: PolygonDesign(
                                    polygon: DesignType.polygon_diamond,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              child: index == pagesLength - 1
                                  ? _finishButton
                                  : _skipButton(setIndex: setIndex))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageModel page(name, children) => PageModel(
        widget: SizedBox(
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                top: stdHorizontalOffset,
                left: stdHorizontalOffset / 2,
                right: stdHorizontalOffset / 2),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: thisTheme.playerColor,
                  border: Border.all(
                    width: 0.0,
                    color: const Color(0x00000000),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: ScrollController(),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                     
                      children: [
                        SizedBox(height: stdHorizontalOffset * 2),
                        Text(
                          name,
                          //style: pageTitleStyle,
                          style: TextStyle(
                              color: thisTheme.onBackground,
                              fontWeight: FontWeight.w700,
                              fontSize: stdFontSize / 20 * 23),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: stdHorizontalOffset),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: stdHorizontalOffset * 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: children,
                            ))
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
}
