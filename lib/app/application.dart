import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../di/domain_managers.dart';
import '../l10n/app_localizations.dart';
import '../utils/theme/ui_values.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _appTitle = 'Pocket Chips';

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        builder: (_, __) => Consumer(
          builder: (_, ref, __) => MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: ref.watch(localeManagerProvider),
            title: _appTitle,
            //TODO: normal theme
            theme: ThemeData(
              primarySwatch: thisTheme.primaryColor,
              fontFamily: 'Ubuntu',
            ),
            routerDelegate: ref.watch(routeDelegateProvider),
            routeInformationParser: ref.watch(routeInformationParserProvider),
          ),
        ),
        designSize: const Size(320, 800),
      );
}
