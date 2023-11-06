import 'package:flutter/material.dart'; // подключаем библиотеку material
import 'package:flutter/services.dart';
import 'package:pocket_chips/data/config_model.dart';
import 'package:pocket_chips/data/logs.dart';
import 'data/storage.dart';
import 'data/uiValues.dart';
import 'internal/application.dart' as app;
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'internal/localization.dart';

//TODO Work with ignore

void _runAp() async {
  await configStorage.read().then((value) {
    thisTheme = themeList[value.themeIndex];
    if (thisTheme == themeList[0]) {
      logs.writeLog('LIGHT mode loaded from config');
    } else {
      logs.writeLog('DARK mode loaded from config');
    }
    thisConfig = value;
  });
  final LocaleManager localeManager = LocaleManager();
  await localeManager.initLocale();
  runApp(
    app.MyApp(
      localeManager: localeManager,
    ),
  );
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    _runAp();
  }
  /*if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('My App');
    setWindowMaxSize(const Size(3840,2160));
    setWindowMinSize(const Size(360, 640));
  }*/

  else if (Platform.isAndroid || Platform.isIOS) {
    //await Purchases.configure(PurchasesConfiguration('goog_oLBnINIENkDvkGoquoIjyBHPcoy'));
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [],
      );
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      //print('Orientation set to portrait');

      _runAp();
    });
  }
}
