import 'package:flutter/material.dart';

import 'models/app_pages.dart';
import 'models/app_route.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    for (final page in AppPage.values) {
      if (uri.path == page.path) {
        switch (page) {
          case AppPage.init:
            // TODO: args support

            // Reading the params from the query or subpaths
            // final args = uri.queryParameters;

            return AppRoute.init();
          case AppPage.menu:
            return AppRoute.menu();
          case AppPage.lobby:
            return AppRoute.lobby();
          case AppPage.game:
            return AppRoute.game();
        }
      }
    }
    // root support
    if (uri.path == '/' || uri.path.isEmpty) {
      return AppRoute.init();
    }

    return AppRoute.init();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) =>
      RouteInformation(
        uri: Uri(path: configuration.page.path),
      );
}
