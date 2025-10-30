// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameStateModel {
  LobbyStateModel get lobbyState;
  GameSessionState get sessionState;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameStateModelCopyWith<GameStateModel> get copyWith =>
      _$GameStateModelCopyWithImpl<GameStateModel>(
          this as GameStateModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameStateModel &&
            (identical(other.lobbyState, lobbyState) ||
                other.lobbyState == lobbyState) &&
            (identical(other.sessionState, sessionState) ||
                other.sessionState == sessionState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lobbyState, sessionState);

  @override
  String toString() {
    return 'GameStateModel(lobbyState: $lobbyState, sessionState: $sessionState)';
  }
}

/// @nodoc
abstract mixin class $GameStateModelCopyWith<$Res> {
  factory $GameStateModelCopyWith(
          GameStateModel value, $Res Function(GameStateModel) _then) =
      _$GameStateModelCopyWithImpl;
  @useResult
  $Res call({LobbyStateModel lobbyState, GameSessionState sessionState});

  $LobbyStateModelCopyWith<$Res> get lobbyState;
  $GameSessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class _$GameStateModelCopyWithImpl<$Res>
    implements $GameStateModelCopyWith<$Res> {
  _$GameStateModelCopyWithImpl(this._self, this._then);

  final GameStateModel _self;
  final $Res Function(GameStateModel) _then;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lobbyState = null,
    Object? sessionState = null,
  }) {
    return _then(_self.copyWith(
      lobbyState: null == lobbyState
          ? _self.lobbyState
          : lobbyState // ignore: cast_nullable_to_non_nullable
              as LobbyStateModel,
      sessionState: null == sessionState
          ? _self.sessionState
          : sessionState // ignore: cast_nullable_to_non_nullable
              as GameSessionState,
    ));
  }

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LobbyStateModelCopyWith<$Res> get lobbyState {
    return $LobbyStateModelCopyWith<$Res>(_self.lobbyState, (value) {
      return _then(_self.copyWith(lobbyState: value));
    });
  }

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameSessionStateCopyWith<$Res> get sessionState {
    return $GameSessionStateCopyWith<$Res>(_self.sessionState, (value) {
      return _then(_self.copyWith(sessionState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [GameStateModel].
extension GameStateModelPatterns on GameStateModel {
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
    TResult Function(_GameStateModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameStateModel() when $default != null:
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
    TResult Function(_GameStateModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameStateModel():
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
    TResult? Function(_GameStateModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameStateModel() when $default != null:
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
    TResult Function(LobbyStateModel lobbyState, GameSessionState sessionState)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameStateModel() when $default != null:
        return $default(_that.lobbyState, _that.sessionState);
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
    TResult Function(LobbyStateModel lobbyState, GameSessionState sessionState)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameStateModel():
        return $default(_that.lobbyState, _that.sessionState);
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
            LobbyStateModel lobbyState, GameSessionState sessionState)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameStateModel() when $default != null:
        return $default(_that.lobbyState, _that.sessionState);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameStateModel implements GameStateModel {
  const _GameStateModel({required this.lobbyState, required this.sessionState});

  @override
  final LobbyStateModel lobbyState;
  @override
  final GameSessionState sessionState;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameStateModelCopyWith<_GameStateModel> get copyWith =>
      __$GameStateModelCopyWithImpl<_GameStateModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameStateModel &&
            (identical(other.lobbyState, lobbyState) ||
                other.lobbyState == lobbyState) &&
            (identical(other.sessionState, sessionState) ||
                other.sessionState == sessionState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lobbyState, sessionState);

  @override
  String toString() {
    return 'GameStateModel(lobbyState: $lobbyState, sessionState: $sessionState)';
  }
}

/// @nodoc
abstract mixin class _$GameStateModelCopyWith<$Res>
    implements $GameStateModelCopyWith<$Res> {
  factory _$GameStateModelCopyWith(
          _GameStateModel value, $Res Function(_GameStateModel) _then) =
      __$GameStateModelCopyWithImpl;
  @override
  @useResult
  $Res call({LobbyStateModel lobbyState, GameSessionState sessionState});

  @override
  $LobbyStateModelCopyWith<$Res> get lobbyState;
  @override
  $GameSessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class __$GameStateModelCopyWithImpl<$Res>
    implements _$GameStateModelCopyWith<$Res> {
  __$GameStateModelCopyWithImpl(this._self, this._then);

  final _GameStateModel _self;
  final $Res Function(_GameStateModel) _then;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lobbyState = null,
    Object? sessionState = null,
  }) {
    return _then(_GameStateModel(
      lobbyState: null == lobbyState
          ? _self.lobbyState
          : lobbyState // ignore: cast_nullable_to_non_nullable
              as LobbyStateModel,
      sessionState: null == sessionState
          ? _self.sessionState
          : sessionState // ignore: cast_nullable_to_non_nullable
              as GameSessionState,
    ));
  }

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LobbyStateModelCopyWith<$Res> get lobbyState {
    return $LobbyStateModelCopyWith<$Res>(_self.lobbyState, (value) {
      return _then(_self.copyWith(lobbyState: value));
    });
  }

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameSessionStateCopyWith<$Res> get sessionState {
    return $GameSessionStateCopyWith<$Res>(_self.sessionState, (value) {
      return _then(_self.copyWith(sessionState: value));
    });
  }
}

// dart format on
