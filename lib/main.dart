import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // подключаем библиотеку material
import 'package:flutter/services.dart';

import 'app/application.dart' as app;
import 'data/storage/storage.dart';
import 'domain/models/config_model.dart';
import 'l10n/localization.dart';
import 'utils/logs.dart';
import 'utils/theme/uiValues.dart';

//TODO Work with ignore

void _runApp() async {
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
    _runApp();
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

      _runApp();
    });
  }
}
