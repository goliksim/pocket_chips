import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_pages.dart';

part 'app_route.freezed.dart';

@freezed
class AppRoute with _$AppRoute {
  const factory AppRoute.init(
      //Object? args
      ) = _InitRoute;

  const factory AppRoute.menu(
      //Object? args
      ) = _MenuRoute;

  const factory AppRoute.lobby(
      //Object? args
      ) = _LobbyRoute;

  const factory AppRoute.game(
      //Object? args
      ) = _GameRoute;

  const AppRoute._();

  AppPage get page => when(
        init: () => AppPage.init,
        menu: () => AppPage.menu,
        lobby: () => AppPage.lobby,
        game: () => AppPage.game,
      );
}
