// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_table_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameTableState {
  List<GamePlayerItem> get players;
  int get tableRotationOffset;
  int get smallBlindValue;
  List<double>? get tablePlayersOffsets;

  /// Create a copy of GameTableState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameTableStateCopyWith<GameTableState> get copyWith =>
      _$GameTableStateCopyWithImpl<GameTableState>(
          this as GameTableState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameTableState &&
            const DeepCollectionEquality().equals(other.players, players) &&
            (identical(other.tableRotationOffset, tableRotationOffset) ||
                other.tableRotationOffset == tableRotationOffset) &&
            (identical(other.smallBlindValue, smallBlindValue) ||
                other.smallBlindValue == smallBlindValue) &&
            const DeepCollectionEquality()
                .equals(other.tablePlayersOffsets, tablePlayersOffsets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      tableRotationOffset,
      smallBlindValue,
      const DeepCollectionEquality().hash(tablePlayersOffsets));

  @override
  String toString() {
    return 'GameTableState(players: $players, tableRotationOffset: $tableRotationOffset, smallBlindValue: $smallBlindValue, tablePlayersOffsets: $tablePlayersOffsets)';
  }
}

/// @nodoc
abstract mixin class $GameTableStateCopyWith<$Res> {
  factory $GameTableStateCopyWith(
          GameTableState value, $Res Function(GameTableState) _then) =
      _$GameTableStateCopyWithImpl;
  @useResult
  $Res call(
      {List<GamePlayerItem> players,
      int tableRotationOffset,
      int smallBlindValue,
      List<double>? tablePlayersOffsets});
}

/// @nodoc
class _$GameTableStateCopyWithImpl<$Res>
    implements $GameTableStateCopyWith<$Res> {
  _$GameTableStateCopyWithImpl(this._self, this._then);

  final GameTableState _self;
  final $Res Function(GameTableState) _then;

  /// Create a copy of GameTableState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? tableRotationOffset = null,
    Object? smallBlindValue = null,
    Object? tablePlayersOffsets = freezed,
  }) {
    return _then(_self.copyWith(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<GamePlayerItem>,
      tableRotationOffset: null == tableRotationOffset
          ? _self.tableRotationOffset
          : tableRotationOffset // ignore: cast_nullable_to_non_nullable
              as int,
      smallBlindValue: null == smallBlindValue
          ? _self.smallBlindValue
          : smallBlindValue // ignore: cast_nullable_to_non_nullable
              as int,
      tablePlayersOffsets: freezed == tablePlayersOffsets
          ? _self.tablePlayersOffsets
          : tablePlayersOffsets // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameTableState].
extension GameTableStatePatterns on GameTableState {
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
    TResult Function(_GameTableState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameTableState() when $default != null:
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
    TResult Function(_GameTableState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameTableState():
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
    TResult? Function(_GameTableState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameTableState() when $default != null:
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
    TResult Function(List<GamePlayerItem> players, int tableRotationOffset,
            int smallBlindValue, List<double>? tablePlayersOffsets)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GameTableState() when $default != null:
        return $default(_that.players, _that.tableRotationOffset,
            _that.smallBlindValue, _that.tablePlayersOffsets);
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
    TResult Function(List<GamePlayerItem> players, int tableRotationOffset,
            int smallBlindValue, List<double>? tablePlayersOffsets)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameTableState():
        return $default(_that.players, _that.tableRotationOffset,
            _that.smallBlindValue, _that.tablePlayersOffsets);
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
    TResult? Function(List<GamePlayerItem> players, int tableRotationOffset,
            int smallBlindValue, List<double>? tablePlayersOffsets)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GameTableState() when $default != null:
        return $default(_that.players, _that.tableRotationOffset,
            _that.smallBlindValue, _that.tablePlayersOffsets);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GameTableState implements GameTableState {
  const _GameTableState(
      {required this.players,
      required this.tableRotationOffset,
      required this.smallBlindValue,
      this.tablePlayersOffsets});

  @override
  final List<GamePlayerItem> players;
  @override
  final int tableRotationOffset;
  @override
  final int smallBlindValue;
  @override
  final List<double>? tablePlayersOffsets;

  /// Create a copy of GameTableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GameTableStateCopyWith<_GameTableState> get copyWith =>
      __$GameTableStateCopyWithImpl<_GameTableState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GameTableState &&
            const DeepCollectionEquality().equals(other.players, players) &&
            (identical(other.tableRotationOffset, tableRotationOffset) ||
                other.tableRotationOffset == tableRotationOffset) &&
            (identical(other.smallBlindValue, smallBlindValue) ||
                other.smallBlindValue == smallBlindValue) &&
            const DeepCollectionEquality()
                .equals(other.tablePlayersOffsets, tablePlayersOffsets));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      tableRotationOffset,
      smallBlindValue,
      const DeepCollectionEquality().hash(tablePlayersOffsets));

  @override
  String toString() {
    return 'GameTableState(players: $players, tableRotationOffset: $tableRotationOffset, smallBlindValue: $smallBlindValue, tablePlayersOffsets: $tablePlayersOffsets)';
  }
}

/// @nodoc
abstract mixin class _$GameTableStateCopyWith<$Res>
    implements $GameTableStateCopyWith<$Res> {
  factory _$GameTableStateCopyWith(
          _GameTableState value, $Res Function(_GameTableState) _then) =
      __$GameTableStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<GamePlayerItem> players,
      int tableRotationOffset,
      int smallBlindValue,
      List<double>? tablePlayersOffsets});
}

/// @nodoc
class __$GameTableStateCopyWithImpl<$Res>
    implements _$GameTableStateCopyWith<$Res> {
  __$GameTableStateCopyWithImpl(this._self, this._then);

  final _GameTableState _self;
  final $Res Function(_GameTableState) _then;

  /// Create a copy of GameTableState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? players = null,
    Object? tableRotationOffset = null,
    Object? smallBlindValue = null,
    Object? tablePlayersOffsets = freezed,
  }) {
    return _then(_GameTableState(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<GamePlayerItem>,
      tableRotationOffset: null == tableRotationOffset
          ? _self.tableRotationOffset
          : tableRotationOffset // ignore: cast_nullable_to_non_nullable
              as int,
      smallBlindValue: null == smallBlindValue
          ? _self.smallBlindValue
          : smallBlindValue // ignore: cast_nullable_to_non_nullable
              as int,
      tablePlayersOffsets: freezed == tablePlayersOffsets
          ? _self.tablePlayersOffsets
          : tablePlayersOffsets // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

// dart format on
