// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_route.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppRoute {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AppRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AppRoute()';
  }
}

/// @nodoc
class $AppRouteCopyWith<$Res> {
  $AppRouteCopyWith(AppRoute _, $Res Function(AppRoute) __);
}

/// Adds pattern-matching-related methods to [AppRoute].
extension AppRoutePatterns on AppRoute {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitRoute value)? init,
    TResult Function(_MenuRoute value)? menu,
    TResult Function(_LobbyRoute value)? lobby,
    TResult Function(_GameRoute value)? game,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute() when init != null:
        return init(_that);
      case _MenuRoute() when menu != null:
        return menu(_that);
      case _LobbyRoute() when lobby != null:
        return lobby(_that);
      case _GameRoute() when game != null:
        return game(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitRoute value) init,
    required TResult Function(_MenuRoute value) menu,
    required TResult Function(_LobbyRoute value) lobby,
    required TResult Function(_GameRoute value) game,
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute():
        return init(_that);
      case _MenuRoute():
        return menu(_that);
      case _LobbyRoute():
        return lobby(_that);
      case _GameRoute():
        return game(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitRoute value)? init,
    TResult? Function(_MenuRoute value)? menu,
    TResult? Function(_LobbyRoute value)? lobby,
    TResult? Function(_GameRoute value)? game,
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute() when init != null:
        return init(_that);
      case _MenuRoute() when menu != null:
        return menu(_that);
      case _LobbyRoute() when lobby != null:
        return lobby(_that);
      case _GameRoute() when game != null:
        return game(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? menu,
    TResult Function()? lobby,
    TResult Function()? game,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute() when init != null:
        return init();
      case _MenuRoute() when menu != null:
        return menu();
      case _LobbyRoute() when lobby != null:
        return lobby();
      case _GameRoute() when game != null:
        return game();
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() menu,
    required TResult Function() lobby,
    required TResult Function() game,
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute():
        return init();
      case _MenuRoute():
        return menu();
      case _LobbyRoute():
        return lobby();
      case _GameRoute():
        return game();
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? menu,
    TResult? Function()? lobby,
    TResult? Function()? game,
  }) {
    final _that = this;
    switch (_that) {
      case _InitRoute() when init != null:
        return init();
      case _MenuRoute() when menu != null:
        return menu();
      case _LobbyRoute() when lobby != null:
        return lobby();
      case _GameRoute() when game != null:
        return game();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InitRoute extends AppRoute {
  const _InitRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _InitRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AppRoute.init()';
  }
}

/// @nodoc

class _MenuRoute extends AppRoute {
  const _MenuRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _MenuRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AppRoute.menu()';
  }
}

/// @nodoc

class _LobbyRoute extends AppRoute {
  const _LobbyRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _LobbyRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AppRoute.lobby()';
  }
}

/// @nodoc

class _GameRoute extends AppRoute {
  const _GameRoute() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GameRoute);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AppRoute.game()';
  }
}

// dart format on
