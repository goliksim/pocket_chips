import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/material.dart'; // подключаем библиотеку material
import 'package:flutter/services.dart';
import 'internal/application.dart' as app;
import 'widgets/test_web.dart' as web;
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';
//import 'package:window_size/window_size.dart';

void _runAp() => runApp(EasyLocalization(
          assetLoader: CsvAssetLoader(),

          supportedLocales: 
          const [Locale('en', 'US'), 
            Locale('ru', 'RU')    
          ],
          path:'assets/translations/langs.csv', 
          fallbackLocale: const Locale('en', 'US'),
          child: const app.MyApp()));
          
    




Future main() async {
  setPathUrlStrategy();
  print('main');
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  if (kIsWeb) {
      print('Not mobile phone');
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
      
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays: [] );
      
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
