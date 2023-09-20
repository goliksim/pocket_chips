import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pages/initPage.dart' as initpage;
import '../data/uiValues.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); 

  
  @override
  Widget build(BuildContext context) {
    
    //Size physicalScreenSize = window.physicalSize;
    //print('${physicalScreenSize.width},${physicalScreenSize.height}');
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            title: 'Pocket Chips',
            theme: ThemeData(primarySwatch: thisTheme.primaryColor, fontFamily:  'Ubuntu'),
            debugShowCheckedModeBanner: false, // скрываем надпись debug
            home: const initpage.InitWindow() // вызов стартовой страницы
            ),
      designSize: const Size(320, 800),
    );
  }
}


