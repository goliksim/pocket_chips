// Конфиг UI. Отступы, стандартные размеры и т.д.
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'storage.dart';
import 'themes.dart';

// Глобальные переменные размеров
late double stdCutoutWidth = 0; 
late double stdCutoutWidthDown = 0;
double stdHeight = 48.h;
final double stdButtonWidth = 400.h;
double stdButtonHeight = 72.h;
late double stdHorizontalOffset = 10.h;
//late double stdEdgeOffset;
late double stdFontSize = 20.h;
late double stdDialogHeight = 208.h;
late double stdIconSize = 28.h;
late double stdBorderRadius = 20.h;
late int standartPlayerCount =5;
late double adaptiveOffset = 15.h;
double stdElevation = 0;

// Глобальные переменные темы. Доступны всем файлам приложухи вроде как.
List themeList = [light, dark];
Themes thisTheme = dark;

void changeTheme(){

    if (thisTheme == themeList[0]) {
    thisTheme = themeList[1];
    thisConfig.themeIndex = 1;
    configStorage.writeConfig(thisConfig);
    } 
    else {
    thisTheme = themeList[0];
    thisConfig.themeIndex = 0;
    configStorage.writeConfig(thisConfig);
    }
  
    logs.writeLog('Turn to ${thisTheme.name} mode');
  }

TextStyle appBarStyle() =>  TextStyle(fontFamily: "Ubuntu", color: thisTheme.onBackground, fontWeight: FontWeight.w500,fontSize: stdFontSize);

TextStyle stdTextStyle =  TextStyle( fontFamily: "Ubuntu", color: thisTheme.onPrimary, fontWeight: FontWeight.w500);
