import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/application.dart';
import 'services/firebase_bootstrapper.dart';

void _runApp() async {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrapper().initialize();

  MobileAds.instance.initialize();

  if (kIsWeb) {
    // Web applications may require their own initialization logic.
    // Now it as it is, but with the possibility of expansion.
    _runApp();
  } else if (Platform.isAndroid || Platform.isIOS) {
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

      _runApp();
    });
  }
}
