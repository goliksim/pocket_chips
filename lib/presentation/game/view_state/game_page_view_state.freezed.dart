// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_page_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamePageViewState {
  GameStatusEnum get gameStatus;
  GameTableState get tableState;
  String get currentGameState;
  bool get canEditPlayer;
  String? get currentPlayerName;

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GamePageViewStateCopyWith<GamePageViewState> get copyWith =>
      _$GamePageViewStateCopyWithImpl<GamePageViewState>(
          this as GamePageViewState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GamePageViewState &&
            (identical(other.gameStatus, gameStatus) ||
                other.gameStatus == gameStatus) &&
            (identical(other.tableState, tableState) ||
                other.tableState == tableState) &&
            (identical(other.currentGameState, currentGameState) ||
                other.currentGameState == currentGameState) &&
            (identical(other.canEditPlayer, canEditPlayer) ||
                other.canEditPlayer == canEditPlayer) &&
            (identical(other.currentPlayerName, currentPlayerName) ||
                other.currentPlayerName == currentPlayerName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameStatus, tableState,
      currentGameState, canEditPlayer, currentPlayerName);

  @override
  String toString() {
    return 'GamePageViewState(gameStatus: $gameStatus, tableState: $tableState, currentGameState: $currentGameState, canEditPlayer: $canEditPlayer, currentPlayerName: $currentPlayerName)';
  }
}

/// @nodoc
abstract mixin class $GamePageViewStateCopyWith<$Res> {
  factory $GamePageViewStateCopyWith(
          GamePageViewState value, $Res Function(GamePageViewState) _then) =
      _$GamePageViewStateCopyWithImpl;
  @useResult
  $Res call(
      {GameStatusEnum gameStatus,
      GameTableState tableState,
      String currentGameState,
      bool canEditPlayer,
      String? currentPlayerName});

  $GameTableStateCopyWith<$Res> get tableState;
}

/// @nodoc
class _$GamePageViewStateCopyWithImpl<$Res>
    implements $GamePageViewStateCopyWith<$Res> {
  _$GamePageViewStateCopyWithImpl(this._self, this._then);

  final GamePageViewState _self;
  final $Res Function(GamePageViewState) _then;

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameStatus = null,
    Object? tableState = null,
    Object? currentGameState = null,
    Object? canEditPlayer = null,
    Object? currentPlayerName = freezed,
  }) {
    return _then(_self.copyWith(
      gameStatus: null == gameStatus
          ? _self.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as GameStatusEnum,
      tableState: null == tableState
          ? _self.tableState
          : tableState // ignore: cast_nullable_to_non_nullable
              as GameTableState,
      currentGameState: null == currentGameState
          ? _self.currentGameState
          : currentGameState // ignore: cast_nullable_to_non_nullable
              as String,
      canEditPlayer: null == canEditPlayer
          ? _self.canEditPlayer
          : canEditPlayer // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPlayerName: freezed == currentPlayerName
          ? _self.currentPlayerName
          : currentPlayerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameTableStateCopyWith<$Res> get tableState {
    return $GameTableStateCopyWith<$Res>(_self.tableState, (value) {
      return _then(_self.copyWith(tableState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GamePageViewState].
extension GamePageViewStatePatterns on GamePageViewState {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamePageViewState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_GamePageViewState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState():
        return $default(_that);
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamePageViewState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            GameStatusEnum gameStatus,
            GameTableState tableState,
            String currentGameState,
            bool canEditPlayer,
            String? currentPlayerName)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState() when $default != null:
        return $default(
            _that.gameStatus,
            _that.tableState,
            _that.currentGameState,
            _that.canEditPlayer,
            _that.currentPlayerName);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            GameStatusEnum gameStatus,
            GameTableState tableState,
            String currentGameState,
            bool canEditPlayer,
            String? currentPlayerName)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState():
        return $default(
            _that.gameStatus,
            _that.tableState,
            _that.currentGameState,
            _that.canEditPlayer,
            _that.currentPlayerName);
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            GameStatusEnum gameStatus,
            GameTableState tableState,
            String currentGameState,
            bool canEditPlayer,
            String? currentPlayerName)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePageViewState() when $default != null:
        return $default(
            _that.gameStatus,
            _that.tableState,
            _that.currentGameState,
            _that.canEditPlayer,
            _that.currentPlayerName);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GamePageViewState implements GamePageViewState {
  const _GamePageViewState(
      {required this.gameStatus,
      required this.tableState,
      required this.currentGameState,
      required this.canEditPlayer,
      this.currentPlayerName});

  @override
  final GameStatusEnum gameStatus;
  @override
  final GameTableState tableState;
  @override
  final String currentGameState;
  @override
  final bool canEditPlayer;
  @override
  final String? currentPlayerName;

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GamePageViewStateCopyWith<_GamePageViewState> get copyWith =>
      __$GamePageViewStateCopyWithImpl<_GamePageViewState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GamePageViewState &&
            (identical(other.gameStatus, gameStatus) ||
                other.gameStatus == gameStatus) &&
            (identical(other.tableState, tableState) ||
                other.tableState == tableState) &&
            (identical(other.currentGameState, currentGameState) ||
                other.currentGameState == currentGameState) &&
            (identical(other.canEditPlayer, canEditPlayer) ||
                other.canEditPlayer == canEditPlayer) &&
            (identical(other.currentPlayerName, currentPlayerName) ||
                other.currentPlayerName == currentPlayerName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, gameStatus, tableState,
      currentGameState, canEditPlayer, currentPlayerName);

  @override
  String toString() {
    return 'GamePageViewState(gameStatus: $gameStatus, tableState: $tableState, currentGameState: $currentGameState, canEditPlayer: $canEditPlayer, currentPlayerName: $currentPlayerName)';
  }
}

/// @nodoc
abstract mixin class _$GamePageViewStateCopyWith<$Res>
    implements $GamePageViewStateCopyWith<$Res> {
  factory _$GamePageViewStateCopyWith(
          _GamePageViewState value, $Res Function(_GamePageViewState) _then) =
      __$GamePageViewStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {GameStatusEnum gameStatus,
      GameTableState tableState,
      String currentGameState,
      bool canEditPlayer,
      String? currentPlayerName});

  @override
  $GameTableStateCopyWith<$Res> get tableState;
}

/// @nodoc
class __$GamePageViewStateCopyWithImpl<$Res>
    implements _$GamePageViewStateCopyWith<$Res> {
  __$GamePageViewStateCopyWithImpl(this._self, this._then);

  final _GamePageViewState _self;
  final $Res Function(_GamePageViewState) _then;

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? gameStatus = null,
    Object? tableState = null,
    Object? currentGameState = null,
    Object? canEditPlayer = null,
    Object? currentPlayerName = freezed,
  }) {
    return _then(_GamePageViewState(
      gameStatus: null == gameStatus
          ? _self.gameStatus
          : gameStatus // ignore: cast_nullable_to_non_nullable
              as GameStatusEnum,
      tableState: null == tableState
          ? _self.tableState
          : tableState // ignore: cast_nullable_to_non_nullable
              as GameTableState,
      currentGameState: null == currentGameState
          ? _self.currentGameState
          : currentGameState // ignore: cast_nullable_to_non_nullable
              as String,
      canEditPlayer: null == canEditPlayer
          ? _self.canEditPlayer
          : canEditPlayer // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPlayerName: freezed == currentPlayerName
          ? _self.currentPlayerName
          : currentPlayerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of GamePageViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameTableStateCopyWith<$Res> get tableState {
    return $GameTableStateCopyWith<$Res>(_self.tableState, (value) {
      return _then(_self.copyWith(tableState: value));
    });
  }
}

// dart format on
