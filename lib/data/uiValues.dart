// Конфиг UI. Отступы, стандартные размеры и т.д.
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'storage.dart';
import 'themes.dart';

// Глобальные переменные размеров
double stdCutoutWidth = 0;
double stdCutoutWidthDown = 0;
double stdHeight = 48.h;
final double stdButtonWidth = 400.h;
double stdButtonHeight = 72.h;
double stdHorizontalOffset = 10.h;
//late double stdEdgeOffset;
double stdFontSize = 20.h;
double stdDialogHeight = 208.h;
double stdIconSize = 28.h;
double stdBorderRadius = 20.h;
int standartPlayerCount = 5;
double adaptiveOffset = 15.h;
double stdElevation = 0;

// Глобальные переменные темы. Доступны всем файлам приложухи вроде как.
List themeList = [light, dark];
Themes thisTheme = dark;

void changeTheme() {
  if (thisTheme == themeList[0]) {
    thisTheme = themeList[1];
    thisConfig.themeIndex = 1;
    configStorage.writeConfig(thisConfig);
  } else {
    thisTheme = themeList[0];
    thisConfig.themeIndex = 0;
    configStorage.writeConfig(thisConfig);
  }

  logs.writeLog('Turn to ${thisTheme.name} mode');
}

TextStyle appBarStyle() => TextStyle(
      fontFamily: 'Ubuntu',
      color: thisTheme.onBackground,
      fontWeight: FontWeight.w500,
      fontSize: stdFontSize,
    );

TextStyle stdTextStyle = TextStyle(
  fontFamily: 'Ubuntu',
  color: thisTheme.onPrimary,
  fontWeight: FontWeight.w500,
);
