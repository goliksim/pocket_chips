// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_editing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerEditingState {
  String get assetUrl;
  bool get makeDealer;
  String? get nameInput;
  int get bankInput;

  /// Create a copy of PlayerEditingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlayerEditingStateCopyWith<PlayerEditingState> get copyWith =>
      _$PlayerEditingStateCopyWithImpl<PlayerEditingState>(
          this as PlayerEditingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlayerEditingState &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.makeDealer, makeDealer) ||
                other.makeDealer == makeDealer) &&
            (identical(other.nameInput, nameInput) ||
                other.nameInput == nameInput) &&
            (identical(other.bankInput, bankInput) ||
                other.bankInput == bankInput));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, assetUrl, makeDealer, nameInput, bankInput);

  @override
  String toString() {
    return 'PlayerEditingState(assetUrl: $assetUrl, makeDealer: $makeDealer, nameInput: $nameInput, bankInput: $bankInput)';
  }
}

/// @nodoc
abstract mixin class $PlayerEditingStateCopyWith<$Res> {
  factory $PlayerEditingStateCopyWith(
          PlayerEditingState value, $Res Function(PlayerEditingState) _then) =
      _$PlayerEditingStateCopyWithImpl;
  @useResult
  $Res call(
      {String assetUrl, bool makeDealer, String? nameInput, int bankInput});
}

/// @nodoc
class _$PlayerEditingStateCopyWithImpl<$Res>
    implements $PlayerEditingStateCopyWith<$Res> {
  _$PlayerEditingStateCopyWithImpl(this._self, this._then);

  final PlayerEditingState _self;
  final $Res Function(PlayerEditingState) _then;

  /// Create a copy of PlayerEditingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assetUrl = null,
    Object? makeDealer = null,
    Object? nameInput = freezed,
    Object? bankInput = null,
  }) {
    return _then(_self.copyWith(
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      makeDealer: null == makeDealer
          ? _self.makeDealer
          : makeDealer // ignore: cast_nullable_to_non_nullable
              as bool,
      nameInput: freezed == nameInput
          ? _self.nameInput
          : nameInput // ignore: cast_nullable_to_non_nullable
              as String?,
      bankInput: null == bankInput
          ? _self.bankInput
          : bankInput // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlayerEditingState].
extension PlayerEditingStatePatterns on PlayerEditingState {
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
    TResult Function(_PlayerEditingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState() when $default != null:
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
    TResult Function(_PlayerEditingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState():
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
    TResult? Function(_PlayerEditingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState() when $default != null:
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
            String assetUrl, bool makeDealer, String? nameInput, int bankInput)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState() when $default != null:
        return $default(
            _that.assetUrl, _that.makeDealer, _that.nameInput, _that.bankInput);
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
            String assetUrl, bool makeDealer, String? nameInput, int bankInput)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState():
        return $default(
            _that.assetUrl, _that.makeDealer, _that.nameInput, _that.bankInput);
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
            String assetUrl, bool makeDealer, String? nameInput, int bankInput)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerEditingState() when $default != null:
        return $default(
            _that.assetUrl, _that.makeDealer, _that.nameInput, _that.bankInput);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlayerEditingState implements PlayerEditingState {
  const _PlayerEditingState(
      {required this.assetUrl,
      required this.makeDealer,
      required this.nameInput,
      required this.bankInput});

  @override
  final String assetUrl;
  @override
  final bool makeDealer;
  @override
  final String? nameInput;
  @override
  final int bankInput;

  /// Create a copy of PlayerEditingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlayerEditingStateCopyWith<_PlayerEditingState> get copyWith =>
      __$PlayerEditingStateCopyWithImpl<_PlayerEditingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlayerEditingState &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.makeDealer, makeDealer) ||
                other.makeDealer == makeDealer) &&
            (identical(other.nameInput, nameInput) ||
                other.nameInput == nameInput) &&
            (identical(other.bankInput, bankInput) ||
                other.bankInput == bankInput));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, assetUrl, makeDealer, nameInput, bankInput);

  @override
  String toString() {
    return 'PlayerEditingState(assetUrl: $assetUrl, makeDealer: $makeDealer, nameInput: $nameInput, bankInput: $bankInput)';
  }
}

/// @nodoc
abstract mixin class _$PlayerEditingStateCopyWith<$Res>
    implements $PlayerEditingStateCopyWith<$Res> {
  factory _$PlayerEditingStateCopyWith(
          _PlayerEditingState value, $Res Function(_PlayerEditingState) _then) =
      __$PlayerEditingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String assetUrl, bool makeDealer, String? nameInput, int bankInput});
}

/// @nodoc
class __$PlayerEditingStateCopyWithImpl<$Res>
    implements _$PlayerEditingStateCopyWith<$Res> {
  __$PlayerEditingStateCopyWithImpl(this._self, this._then);

  final _PlayerEditingState _self;
  final $Res Function(_PlayerEditingState) _then;

  /// Create a copy of PlayerEditingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assetUrl = null,
    Object? makeDealer = null,
    Object? nameInput = freezed,
    Object? bankInput = null,
  }) {
    return _then(_PlayerEditingState(
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      makeDealer: null == makeDealer
          ? _self.makeDealer
          : makeDealer // ignore: cast_nullable_to_non_nullable
              as bool,
      nameInput: freezed == nameInput
          ? _self.nameInput
          : nameInput // ignore: cast_nullable_to_non_nullable
              as String?,
      bankInput: null == bankInput
          ? _self.bankInput
          : bankInput // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
