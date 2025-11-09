// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSessionState {
  Map<String, int> get bets;
  Set<String> get foldedPlayers;
  int get lapCounter;
  String? get currentPlayerUid;
  String? get firstPlayerUid;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameSessionStateCopyWith<GameSessionState> get copyWith =>
      _$GameSessionStateCopyWithImpl<GameSessionState>(
          this as GameSessionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameSessionState &&
            const DeepCollectionEquality().equals(other.bets, bets) &&
            const DeepCollectionEquality()
                .equals(other.foldedPlayers, foldedPlayers) &&
            (identical(other.lapCounter, lapCounter) ||
                other.lapCounter == lapCounter) &&
            (identical(other.currentPlayerUid, currentPlayerUid) ||
                other.currentPlayerUid == currentPlayerUid) &&
            (identical(other.firstPlayerUid, firstPlayerUid) ||
                other.firstPlayerUid == firstPlayerUid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bets),
      const DeepCollectionEquality().hash(foldedPlayers),
      lapCounter,
      currentPlayerUid,
      firstPlayerUid);

  @override
  String toString() {
    return 'GameSessionState(bets: $bets, foldedPlayers: $foldedPlayers, lapCounter: $lapCounter, currentPlayerUid: $currentPlayerUid, firstPlayerUid: $firstPlayerUid)';
  }
}

/// @nodoc
abstract mixin class $GameSessionStateCopyWith<$Res> {
  factory $GameSessionStateCopyWith(
          GameSessionState value, $Res Function(GameSessionState) _then) =
      _$GameSessionStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, int> bets,
      Set<String> foldedPlayers,
      int lapCounter,
      String? currentPlayerUid,
      String? firstPlayerUid});
}

/// @nodoc
class _$GameSessionStateCopyWithImpl<$Res>
    implements $GameSessionStateCopyWith<$Res> {
  _$GameSessionStateCopyWithImpl(this._self, this._then);

  final GameSessionState _self;
  final $Res Function(GameSessionState) _then;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bets = null,
    Object? foldedPlayers = null,
    Object? lapCounter = null,
    Object? currentPlayerUid = freezed,
    Object? firstPlayerUid = freezed,
  }) {
    return _then(_self.copyWith(
      bets: null == bets
          ? _self.bets
          : bets // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      foldedPlayers: null == foldedPlayers
          ? _self.foldedPlayers
          : foldedPlayers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      lapCounter: null == lapCounter
          ? _self.lapCounter
          : lapCounter // ignore: cast_nullable_to_non_nullable
              as int,
      currentPlayerUid: freezed == currentPlayerUid
          ? _self.currentPlayerUid
          : currentPlayerUid // ignore: cast_nullable_to_non_nullable
              as String?,
      firstPlayerUid: freezed == firstPlayerUid
          ? _self.firstPlayerUid
          : firstPlayerUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameSessionState].
extension GameSessionStatePatterns on GameSessionState {
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
    TResult Function(_GameSessionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameSessionState() when $default != null:
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
    TResult Function(_GameSessionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameSessionState():
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
    TResult? Function(_GameSessionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameSessionState() when $default != null:
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
    TResult Function(Map<String, int> bets, Set<String> foldedPlayers,
            int lapCounter, String? currentPlayerUid, String? firstPlayerUid)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameSessionState() when $default != null:
        return $default(_that.bets, _that.foldedPlayers, _that.lapCounter,
            _that.currentPlayerUid, _that.firstPlayerUid);
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
    TResult Function(Map<String, int> bets, Set<String> foldedPlayers,
            int lapCounter, String? currentPlayerUid, String? firstPlayerUid)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameSessionState():
        return $default(_that.bets, _that.foldedPlayers, _that.lapCounter,
            _that.currentPlayerUid, _that.firstPlayerUid);
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
    TResult? Function(Map<String, int> bets, Set<String> foldedPlayers,
            int lapCounter, String? currentPlayerUid, String? firstPlayerUid)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameSessionState() when $default != null:
        return $default(_that.bets, _that.foldedPlayers, _that.lapCounter,
            _that.currentPlayerUid, _that.firstPlayerUid);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameSessionState implements GameSessionState {
  const _GameSessionState(
      {required this.bets,
      required this.foldedPlayers,
      required this.lapCounter,
      this.currentPlayerUid,
      this.firstPlayerUid});

  @override
  final Map<String, int> bets;
  @override
  final Set<String> foldedPlayers;
  @override
  final int lapCounter;
  @override
  final String? currentPlayerUid;
  @override
  final String? firstPlayerUid;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameSessionStateCopyWith<_GameSessionState> get copyWith =>
      __$GameSessionStateCopyWithImpl<_GameSessionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameSessionState &&
            const DeepCollectionEquality().equals(other.bets, bets) &&
            const DeepCollectionEquality()
                .equals(other.foldedPlayers, foldedPlayers) &&
            (identical(other.lapCounter, lapCounter) ||
                other.lapCounter == lapCounter) &&
            (identical(other.currentPlayerUid, currentPlayerUid) ||
                other.currentPlayerUid == currentPlayerUid) &&
            (identical(other.firstPlayerUid, firstPlayerUid) ||
                other.firstPlayerUid == firstPlayerUid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(bets),
      const DeepCollectionEquality().hash(foldedPlayers),
      lapCounter,
      currentPlayerUid,
      firstPlayerUid);

  @override
  String toString() {
    return 'GameSessionState(bets: $bets, foldedPlayers: $foldedPlayers, lapCounter: $lapCounter, currentPlayerUid: $currentPlayerUid, firstPlayerUid: $firstPlayerUid)';
  }
}

/// @nodoc
abstract mixin class _$GameSessionStateCopyWith<$Res>
    implements $GameSessionStateCopyWith<$Res> {
  factory _$GameSessionStateCopyWith(
          _GameSessionState value, $Res Function(_GameSessionState) _then) =
      __$GameSessionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, int> bets,
      Set<String> foldedPlayers,
      int lapCounter,
      String? currentPlayerUid,
      String? firstPlayerUid});
}

/// @nodoc
class __$GameSessionStateCopyWithImpl<$Res>
    implements _$GameSessionStateCopyWith<$Res> {
  __$GameSessionStateCopyWithImpl(this._self, this._then);

  final _GameSessionState _self;
  final $Res Function(_GameSessionState) _then;

  /// Create a copy of GameSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bets = null,
    Object? foldedPlayers = null,
    Object? lapCounter = null,
    Object? currentPlayerUid = freezed,
    Object? firstPlayerUid = freezed,
  }) {
    return _then(_GameSessionState(
      bets: null == bets
          ? _self.bets
          : bets // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      foldedPlayers: null == foldedPlayers
          ? _self.foldedPlayers
          : foldedPlayers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      lapCounter: null == lapCounter
          ? _self.lapCounter
          : lapCounter // ignore: cast_nullable_to_non_nullable
              as int,
      currentPlayerUid: freezed == currentPlayerUid
          ? _self.currentPlayerUid
          : currentPlayerUid // ignore: cast_nullable_to_non_nullable
              as String?,
      firstPlayerUid: freezed == firstPlayerUid
          ? _self.firstPlayerUid
          : firstPlayerUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
