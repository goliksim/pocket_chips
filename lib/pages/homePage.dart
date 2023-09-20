// ignore_for_file: file_names
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/support.dart';
import '../pages/playersPage.dart' as players;
import '../data/lobby.dart';
import '../data/storage.dart';
import '../ui/transitions.dart';
import '../widgets/onboarding.dart';
import '../data/uiValues.dart';
import '../ui/ui_widgets.dart';





class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.isDark}) //
      : super(key: key); // принимает значение title при обращении
  
  final bool isDark;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String title = 'POCKET CHIPS';
  

  Future<void> newGame(BuildContext context) async {
    thisLobby = Lobby(lobbyPlayers: [],);
    logs.writeLog('Switch to PlayerPage(NewGame)');
    Navigator.push(context, simpleSlidePageRoute(const players.PlayersPage())).then((_) {
      logs.writeLog('Returned to HomePage');
      setState(() {});
    } );
  }

  @override
  void initState(){
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (thisConfig.firstTime) firstTime();
    });
     
  }

  void firstTime() async{
    showHelp(context,callBack,onWillpop:false);
  } 

  void callBack(){
   // print('homepage callback');
    setState(() {
    });
  }

  Widget homePageButtons(context) => SizedBox(
      height: stdButtonHeight * 2 +
          stdHorizontalOffset * 2 +
          ((thisLobby.lobbyPlayers.isNotEmpty) ? (stdButtonHeight) : 0),
      child: Column(
        children: [
          if ((thisLobby.lobbyPlayers.isNotEmpty))
            //Continue
            MyButton(
              height: stdButtonHeight,
              width: double.infinity,
              borderRadius: BorderRadius.circular(stdBorderRadius),
              buttonColor: thisTheme.primaryColor,
              textString: 'home.cont'.tr(),
              action: () {
                logs.writeLog('Switch to PlayerPage(Continue)');
                Navigator.push(
                        context, simpleSlidePageRoute(const players.PlayersPage()))
                    .then((_) {
                  logs.writeLog('Returned to HomePage');
                  setState(() {});
                }); //SlidePageRoute(direction: AxisDirection.left, child:  players.PlayersPage(), childCurrent: widget));
              },
            ),
            SizedBox(height: stdHorizontalOffset),
            //New Game
            MyButton(
              height: stdButtonHeight,
              width: double.infinity,
              borderRadius: BorderRadius.circular(stdBorderRadius),
              buttonColor: (thisLobby.lobbyPlayers.isNotEmpty)
                  ? thisTheme.secondaryColor
                  : thisTheme.primaryColor,
              textString: 'home.new'.tr(),
              action: () async {
              if (thisLobby.lobbyPlayers.isNotEmpty) {
                await showDialog(
                  context: context,
                  builder: (BuildContext thisContext) {
                    return ConfirmationWindow(
                        type: "home.new".tr(),
                        button: 'home.new'.tr(),
                        message:
                            "conf.new.text1".tr()+'\n'+"conf.new.text2".tr(),
                        action: () => newGame(context));
                        
                  },
                );
              } else {
                newGame(context);
              }
            },
          ),
            SizedBox(height: stdHorizontalOffset),

          //Our Contacts
          Row(
            children: [
              Expanded(
                child: 
                MyButton(
                  height: stdButtonHeight,
                  borderRadius: BorderRadius.circular(stdBorderRadius),
                  buttonColor: thisTheme.additionButtonColor,
                  textString: 'home.abo'.tr(),
                  action: () async {
                    showHelp(context, callBack,
                        onWillpop:
                            true); //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyApp()));
                  },
                ),
                ),
                if (!kIsWeb) SizedBox(
                  width: stdHorizontalOffset,
                ),
              if (!kIsWeb) Expanded(
                child: 
                  MyButton(
                    height: stdButtonHeight,
                    borderRadius: BorderRadius.circular(stdBorderRadius),
                    buttonColor: thisTheme.additionButtonColor,
                    textString: 'home.sup'.tr(),
                    action: () async {
                      showDonate(context, callBack);
                      //const url = 'https://github.com/goliksim';
                      //if (!await launch(url)) throw 'Could not launch $url';
                    },
                  ),
              ),
            ],
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: double.infinity,
      color: thisTheme.bgrColor,
            child:PatternContainer(
              padding: EdgeInsets.only(top: stdCutoutWidth*0.75,bottom: stdCutoutWidthDown*0.75),
 
      child: Scaffold(
          appBar: AppBar(
            
            leading: null,
            /*
            IconButton(
              onPressed: () =>  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const MyApp())),
                icon: Icon(
                  Icons.info_outline,
                  size: stdIconSize,
                ),
                tooltip: 'Help',
              ),*/
            
            toolbarHeight: stdButtonHeight*0.75,
            automaticallyImplyLeading: false, //убрать стрелочку, так как это стартовая страница
            backgroundColor: const Color(0x00000000),
            iconTheme: IconThemeData(
              color: thisTheme.onBackground, //change your color here
            ),
            elevation: 0,
            centerTitle: true,
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: appBarStyle().copyWith(fontWeight: FontWeight.w700, fontSize: stdFontSize/20*28 ),// aGoogleFonts.josefinSans(color: thisTheme.onBackground, fontWeight: FontWeight.w700,fontSize: 1.2* windowTextFix(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
            ),
            
            actions: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: IconButton(
                  //padding: EdgeInsets.only(right: 25.w),
                  icon: Icon(
                    (thisTheme == themeList[0])? Icons.mode_night_outlined: Icons.nightlight_round,
                    size: stdIconSize,
                  ),
                  tooltip: 'tooltip.theme'.tr(),
                  onPressed: () async{
                    changeTheme();
                    Navigator.pushReplacement(context, simpleThemePageRoute(HomePage(isDark: !widget.isDark)));
                    //setState({});
                  },    
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body:  Center(
            child: Container(
                  width: stdButtonWidth,
                  margin: EdgeInsets.only(
                      //vertical: stdEdgeOffset,
                      bottom: adaptiveOffset,
                      left: adaptiveOffset,//  windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width),
                      right: adaptiveOffset),
                  child: Center(
                      child:
                          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    
                    Expanded(
                      child: chipImage(context)
                    ),
                    //кнопочки
                      homePageButtons(context),
                      
                  ])),
                ),
          ) 
            
          ),
        ),
    );
    
  }
  
  

}

Widget chipImage(context) => Container(
      margin: EdgeInsets.all(stdHorizontalOffset),
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
              thisTheme.bgrColor.withOpacity(0.95), BlendMode.dstIn),
          fit: BoxFit.contain,
          image: const AssetImage('assets/init_logo.png'),
        ),
      ),
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width,
    );

Future showHelp(BuildContext context, callBack, {onWillpop=false}) => transitionDialog(
                    duration: const Duration(milliseconds: 400),
                    type: "Scale", 
                    context: context,
                    child: WillPopScope(
                onWillPop: () async => onWillpop,
                child: MyApp(callbackFunction: callBack)),
                    builder: (BuildContext context) {
                    return MyApp(callbackFunction: callBack);
                    });

Future showDonate(BuildContext context, callBack) => transitionDialog(
                    duration: const Duration(milliseconds: 400),
                    type: "Scale", 
                    context: context,
                    child: DonateWindow(callbackFunction: callBack),
                    builder: (BuildContext context) {
                    return DonateWindow(callbackFunction: callBack);
                    });

