// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_page_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobbyPageState {
  List<LobbyPlayerItem> get players;
  bool get gameActive;
  bool get canEditPlayers;
  bool get canAddPlayer;
  int get startingStack;

  /// Create a copy of LobbyPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LobbyPageStateCopyWith<LobbyPageState> get copyWith =>
      _$LobbyPageStateCopyWithImpl<LobbyPageState>(
          this as LobbyPageState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LobbyPageState &&
            const DeepCollectionEquality().equals(other.players, players) &&
            (identical(other.gameActive, gameActive) ||
                other.gameActive == gameActive) &&
            (identical(other.canEditPlayers, canEditPlayers) ||
                other.canEditPlayers == canEditPlayers) &&
            (identical(other.canAddPlayer, canAddPlayer) ||
                other.canAddPlayer == canAddPlayer) &&
            (identical(other.startingStack, startingStack) ||
                other.startingStack == startingStack));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      gameActive,
      canEditPlayers,
      canAddPlayer,
      startingStack);

  @override
  String toString() {
    return 'LobbyPageState(players: $players, gameActive: $gameActive, canEditPlayers: $canEditPlayers, canAddPlayer: $canAddPlayer, startingStack: $startingStack)';
  }
}

/// @nodoc
abstract mixin class $LobbyPageStateCopyWith<$Res> {
  factory $LobbyPageStateCopyWith(
          LobbyPageState value, $Res Function(LobbyPageState) _then) =
      _$LobbyPageStateCopyWithImpl;
  @useResult
  $Res call(
      {List<LobbyPlayerItem> players,
      bool gameActive,
      bool canEditPlayers,
      bool canAddPlayer,
      int startingStack});
}

/// @nodoc
class _$LobbyPageStateCopyWithImpl<$Res>
    implements $LobbyPageStateCopyWith<$Res> {
  _$LobbyPageStateCopyWithImpl(this._self, this._then);

  final LobbyPageState _self;
  final $Res Function(LobbyPageState) _then;

  /// Create a copy of LobbyPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? gameActive = null,
    Object? canEditPlayers = null,
    Object? canAddPlayer = null,
    Object? startingStack = null,
  }) {
    return _then(_self.copyWith(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<LobbyPlayerItem>,
      gameActive: null == gameActive
          ? _self.gameActive
          : gameActive // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditPlayers: null == canEditPlayers
          ? _self.canEditPlayers
          : canEditPlayers // ignore: cast_nullable_to_non_nullable
              as bool,
      canAddPlayer: null == canAddPlayer
          ? _self.canAddPlayer
          : canAddPlayer // ignore: cast_nullable_to_non_nullable
              as bool,
      startingStack: null == startingStack
          ? _self.startingStack
          : startingStack // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [LobbyPageState].
extension LobbyPageStatePatterns on LobbyPageState {
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
    TResult Function(_LobbyPageState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState() when $default != null:
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
    TResult Function(_LobbyPageState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState():
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
    TResult? Function(_LobbyPageState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState() when $default != null:
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
    TResult Function(List<LobbyPlayerItem> players, bool gameActive,
            bool canEditPlayers, bool canAddPlayer, int startingStack)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState() when $default != null:
        return $default(_that.players, _that.gameActive, _that.canEditPlayers,
            _that.canAddPlayer, _that.startingStack);
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
    TResult Function(List<LobbyPlayerItem> players, bool gameActive,
            bool canEditPlayers, bool canAddPlayer, int startingStack)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState():
        return $default(_that.players, _that.gameActive, _that.canEditPlayers,
            _that.canAddPlayer, _that.startingStack);
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
    TResult? Function(List<LobbyPlayerItem> players, bool gameActive,
            bool canEditPlayers, bool canAddPlayer, int startingStack)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPageState() when $default != null:
        return $default(_that.players, _that.gameActive, _that.canEditPlayers,
            _that.canAddPlayer, _that.startingStack);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LobbyPageState implements LobbyPageState {
  const _LobbyPageState(
      {required this.players,
      required this.gameActive,
      required this.canEditPlayers,
      required this.canAddPlayer,
      required this.startingStack});

  @override
  final List<LobbyPlayerItem> players;
  @override
  final bool gameActive;
  @override
  final bool canEditPlayers;
  @override
  final bool canAddPlayer;
  @override
  final int startingStack;

  /// Create a copy of LobbyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LobbyPageStateCopyWith<_LobbyPageState> get copyWith =>
      __$LobbyPageStateCopyWithImpl<_LobbyPageState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LobbyPageState &&
            const DeepCollectionEquality().equals(other.players, players) &&
            (identical(other.gameActive, gameActive) ||
                other.gameActive == gameActive) &&
            (identical(other.canEditPlayers, canEditPlayers) ||
                other.canEditPlayers == canEditPlayers) &&
            (identical(other.canAddPlayer, canAddPlayer) ||
                other.canAddPlayer == canAddPlayer) &&
            (identical(other.startingStack, startingStack) ||
                other.startingStack == startingStack));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      gameActive,
      canEditPlayers,
      canAddPlayer,
      startingStack);

  @override
  String toString() {
    return 'LobbyPageState(players: $players, gameActive: $gameActive, canEditPlayers: $canEditPlayers, canAddPlayer: $canAddPlayer, startingStack: $startingStack)';
  }
}

/// @nodoc
abstract mixin class _$LobbyPageStateCopyWith<$Res>
    implements $LobbyPageStateCopyWith<$Res> {
  factory _$LobbyPageStateCopyWith(
          _LobbyPageState value, $Res Function(_LobbyPageState) _then) =
      __$LobbyPageStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<LobbyPlayerItem> players,
      bool gameActive,
      bool canEditPlayers,
      bool canAddPlayer,
      int startingStack});
}

/// @nodoc
class __$LobbyPageStateCopyWithImpl<$Res>
    implements _$LobbyPageStateCopyWith<$Res> {
  __$LobbyPageStateCopyWithImpl(this._self, this._then);

  final _LobbyPageState _self;
  final $Res Function(_LobbyPageState) _then;

  /// Create a copy of LobbyPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? players = null,
    Object? gameActive = null,
    Object? canEditPlayers = null,
    Object? canAddPlayer = null,
    Object? startingStack = null,
  }) {
    return _then(_LobbyPageState(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<LobbyPlayerItem>,
      gameActive: null == gameActive
          ? _self.gameActive
          : gameActive // ignore: cast_nullable_to_non_nullable
              as bool,
      canEditPlayers: null == canEditPlayers
          ? _self.canEditPlayers
          : canEditPlayers // ignore: cast_nullable_to_non_nullable
              as bool,
      canAddPlayer: null == canAddPlayer
          ? _self.canAddPlayer
          : canAddPlayer // ignore: cast_nullable_to_non_nullable
              as bool,
      startingStack: null == startingStack
          ? _self.startingStack
          : startingStack // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
