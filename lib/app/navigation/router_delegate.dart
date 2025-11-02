import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../presentation/game/game_page.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/init/init_page.dart';
import '../../presentation/lobby/lobby_page.dart';
import 'models/app_route.dart';
import 'navigation_manager.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationManager navigationManager;

  AppRouterDelegate({
    required this.navigationManager,
    required this.navigatorKey,
  }) {
    navigationManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    final target = navigationManager.state;

    List<Page> pages = [];

    pages.add(
      MaterialPage(
        name: target.page.routeName,
        child: Consumer(
          builder: (_, ref, __) => target.map(
            init: (_) => InitPage(
              viewModel: ref.watch(initPageViewModelProvider),
            ),
            menu: (_) => HomePage(),
            lobby: (_) => LobbyPage(),
            game: (_) {
              //final args = route.args;

              return GamePage();
            },
          ),
        ),
      ),
    );

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (_) {},
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async =>
      navigationManager.goTo(configuration);
}
