import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/view_models.dart';
import '../../presentation/common/transitions.dart';
import '../../presentation/game/game_page.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/init/init_page.dart';
import '../../presentation/lobby/lobby_page.dart';
import '../../presentation/monitization/ads/banner_ads_wrapper.dart';
import '../theme_provider.dart';
import 'models/app_route.dart';
import 'navigation_manager.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigationManager navigationManager;
  final List<NavigatorObserver> observers;

  AppRouterDelegate({
    required this.navigationManager,
    required this.navigatorKey,
    required this.observers,
  }) {
    navigationManager.addListener(notifyListeners);
  }

  @override
  Widget build(BuildContext context) {
    final stack = navigationManager.stack;

    List<Page> pages = stack
        .map((route) => route.map(
              init: (_) => MaterialPage(
                child: Consumer(
                  builder: (_, ref, __) => InitPage(
                    viewModel: ref.watch(initPageViewModelProvider),
                  ),
                ),
              ),
              menu: (_) => FadedPage(
                child: AnimatedHomePage(),
              ),
              lobby: (_) => SlidedPade(
                child: LobbyPage(),
              ),
              game: (_) => SlidedPade(
                child: GamePage(),
              ),
            ))
        .toList(growable: false);

    return AppThemeBuilder(
      builder: (context, theme) => BannerAdWrapper(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          observers: observers,
          // TODO: refactor to use onDidRemovePage
          //ignore: deprecated_member_use
          onPopPage: (route, result) {
            final didPop = route.didPop(result);
            if (!didPop) return false;

            final wasHandled = navigationManager.handleBackNavigation();
            return wasHandled;
          },
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async =>
      navigationManager.goTo(configuration);
}
