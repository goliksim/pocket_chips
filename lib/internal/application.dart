import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../pages/initPage.dart' as initpage;
import '../data/uiValues.dart';
import 'localization.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.localeManager}) : super(key: key);
  final LocaleManager localeManager;

  @override
  MyAppState createState() => MyAppState();
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
}

class MyAppState extends State<MyApp> {
  void setLocale(Locale value) {
    widget.localeManager.changeLocale(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //Size physicalScreenSize = window.physicalSize;
    //print('${physicalScreenSize.width},${physicalScreenSize.height}');
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: widget.localeManager.lang,
        //locale: context.locale,
        title: 'Pocket Chips',
        theme: ThemeData(
          primarySwatch: thisTheme.primaryColor,
          fontFamily: 'Ubuntu',
        ),
        debugShowCheckedModeBanner: false, // скрываем надпись debug
        home: const initpage.InitWindow(), // вызов стартовой страницы
      ),
      designSize: const Size(320, 800),
    );
  }
}
