import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/application.dart';

void _runApp() async {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Для веб-приложений может потребоваться своя логика инициализации.
    // Пока оставим как есть, но с возможностью расширения.
    _runApp();
  } else if (Platform.isAndroid || Platform.isIOS) {
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
