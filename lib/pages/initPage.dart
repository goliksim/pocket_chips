// ignore_for_file: file_names

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../data/lobby.dart';
import '../data/storage.dart';
import '../ui/transitions.dart';
import '../data/uiValues.dart';
import 'homePage.dart';



class InitWindow extends StatefulWidget {
  const InitWindow({Key? key}) : super(key: key);

  @override
  State<InitWindow> createState() => _InitWindowState();
}

class _InitWindowState extends State<InitWindow> {

  late Timer _timer;
  int _start = -150;
  bool loadingBool = false;
  //late AdvancedIconState _state;// = AdvancedIconState.primary ;
  
  void startTimer({bool end = false}) async{
    if (end){
      await Future.delayed(const Duration(milliseconds: 900));
      logs.writeLog('Switch to HomePage');
        Navigator.pushReplacement(context, simpleFadePageRoute(HomePage(isDark: thisTheme.name == themeList[1])));
      
          }
    else{
      const oneSec = Duration(milliseconds: 20);
      _timer = Timer.periodic(oneSec,(Timer timer){
      if (_start == 1000) {
        setState(() {
          timer.cancel();
          //print('timer ended');
          startTimer(end: loadingBool);
        });
      } else {
        setState(() {
          _start+=10;
        });
      }
    },
  );
  }
  }

  Future loading() async{

    configStorage.readConfig().then((value) {
      thisTheme = themeList[value.themeIndex];
      if (thisTheme == themeList[0]) {
        logs.writeLog('LIGHT mode loaded from config');
        }
      else {
        logs.writeLog('DARK mode loaded from config');
      }
      thisConfig = value;
    });
      lobbyStorage.readLobby().then((value) {
        setState(() {
          thisLobby = value;
        });
      });
      savedStorage.readPlayers().then((value) {
        setState(() {
          savedPlayers = value;
        });
      });
      loadingBool = true;
  }

  @override
  void initState() {
    //Android fullscreen
    super.initState();
    stdCutoutWidth = MediaQueryData.fromWindow(window).systemGestureInsets.top;
    stdCutoutWidthDown = MediaQueryData.fromWindow(window).systemGestureInsets.bottom;
    print(stdCutoutWidthDown);
    print(stdCutoutWidth);
    stdCutoutWidth = stdCutoutWidth>=48? stdCutoutWidth: 0;
    stdCutoutWidthDown = stdCutoutWidthDown>48? stdCutoutWidthDown/2: 0;
    print(stdCutoutWidthDown);


      startTimer();
      loading();
    // загрузка лобби из памяти !!!!!!!!!!
  }

  @override
  void dispose() {
   
    super.dispose();
    _timer.cancel();
  }
  
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: thisTheme.bgrColor,
      padding: EdgeInsets.only(top: stdCutoutWidth*0.75,bottom: stdCutoutWidthDown*0.75),
 
      child:Scaffold(
      appBar: AppBar(
          leading: null,
          toolbarHeight: stdButtonHeight*0.75,
          automaticallyImplyLeading: false, //убрать стрелочку, так как это стартовая страница
          backgroundColor: const Color(0x00000000),
          iconTheme: IconThemeData(
            color: thisTheme.onBackground, //change your color here
          ),
          elevation: 0,
        ),
      backgroundColor: thisTheme.bgrColor,
      body: Center(
        child: Opacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _start > 0? (_start/1000): 0.0,
         
          // The green box must be a child of the AnimatedOpacity widget.
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
                child: chipImage(context),
              ),
              //кнопочки
              // Continue
              SizedBox(height: stdButtonHeight*2 + stdHorizontalOffset*2 + ((thisLobby.lobbyPlayers.isNotEmpty)?(stdButtonHeight):0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                FittedBox(child: Text('POCKET CHIPS',textAlign: TextAlign.center,style: appBarStyle().copyWith(fontWeight: FontWeight.w700, fontSize: stdFontSize*2.35,color: thisTheme.primaryColor))),
                Text('created by goliksim',style: appBarStyle().copyWith(fontWeight: FontWeight.w500, fontSize: stdFontSize)),
                SizedBox(height:stdButtonHeight*1),
              ],),
              )
            ])
            ),
          ),
        ), 
      ),
    ),
  );
  }
}

