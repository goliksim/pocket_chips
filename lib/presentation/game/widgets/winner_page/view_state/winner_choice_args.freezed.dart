// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'winner_choice_args.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WinnerChoiceArgs {
  String get title;
  List<PossibleWinnerItem> get possibleWinners;

  /// Create a copy of WinnerChoiceArgs
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WinnerChoiceArgsCopyWith<WinnerChoiceArgs> get copyWith =>
      _$WinnerChoiceArgsCopyWithImpl<WinnerChoiceArgs>(
          this as WinnerChoiceArgs, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WinnerChoiceArgs &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.possibleWinners, possibleWinners));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, const DeepCollectionEquality().hash(possibleWinners));

  @override
  String toString() {
    return 'WinnerChoiceArgs(title: $title, possibleWinners: $possibleWinners)';
  }
}

/// @nodoc
abstract mixin class $WinnerChoiceArgsCopyWith<$Res> {
  factory $WinnerChoiceArgsCopyWith(
          WinnerChoiceArgs value, $Res Function(WinnerChoiceArgs) _then) =
      _$WinnerChoiceArgsCopyWithImpl;
  @useResult
  $Res call({String title, List<PossibleWinnerItem> possibleWinners});
}

/// @nodoc
class _$WinnerChoiceArgsCopyWithImpl<$Res>
    implements $WinnerChoiceArgsCopyWith<$Res> {
  _$WinnerChoiceArgsCopyWithImpl(this._self, this._then);

  final WinnerChoiceArgs _self;
  final $Res Function(WinnerChoiceArgs) _then;

  /// Create a copy of WinnerChoiceArgs
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? possibleWinners = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      possibleWinners: null == possibleWinners
          ? _self.possibleWinners
          : possibleWinners // ignore: cast_nullable_to_non_nullable
              as List<PossibleWinnerItem>,
    ));
  }
}

/// Adds pattern-matching-related methods to [WinnerChoiceArgs].
extension WinnerChoiceArgsPatterns on WinnerChoiceArgs {
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
    TResult Function(_WinnerChoiceArgs value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs() when $default != null:
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
    TResult Function(_WinnerChoiceArgs value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs():
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
    TResult? Function(_WinnerChoiceArgs value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs() when $default != null:
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
    TResult Function(String title, List<PossibleWinnerItem> possibleWinners)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs() when $default != null:
        return $default(_that.title, _that.possibleWinners);
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
    TResult Function(String title, List<PossibleWinnerItem> possibleWinners)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs():
        return $default(_that.title, _that.possibleWinners);
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
    TResult? Function(String title, List<PossibleWinnerItem> possibleWinners)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WinnerChoiceArgs() when $default != null:
        return $default(_that.title, _that.possibleWinners);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WinnerChoiceArgs implements WinnerChoiceArgs {
  const _WinnerChoiceArgs({required this.title, required this.possibleWinners});

  @override
  final String title;
  @override
  final List<PossibleWinnerItem> possibleWinners;

  /// Create a copy of WinnerChoiceArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WinnerChoiceArgsCopyWith<_WinnerChoiceArgs> get copyWith =>
      __$WinnerChoiceArgsCopyWithImpl<_WinnerChoiceArgs>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WinnerChoiceArgs &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other.possibleWinners, possibleWinners));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, const DeepCollectionEquality().hash(possibleWinners));

  @override
  String toString() {
    return 'WinnerChoiceArgs(title: $title, possibleWinners: $possibleWinners)';
  }
}

/// @nodoc
abstract mixin class _$WinnerChoiceArgsCopyWith<$Res>
    implements $WinnerChoiceArgsCopyWith<$Res> {
  factory _$WinnerChoiceArgsCopyWith(
          _WinnerChoiceArgs value, $Res Function(_WinnerChoiceArgs) _then) =
      __$WinnerChoiceArgsCopyWithImpl;
  @override
  @useResult
  $Res call({String title, List<PossibleWinnerItem> possibleWinners});
}

/// @nodoc
class __$WinnerChoiceArgsCopyWithImpl<$Res>
    implements _$WinnerChoiceArgsCopyWith<$Res> {
  __$WinnerChoiceArgsCopyWithImpl(this._self, this._then);

  final _WinnerChoiceArgs _self;
  final $Res Function(_WinnerChoiceArgs) _then;

  /// Create a copy of WinnerChoiceArgs
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? possibleWinners = null,
  }) {
    return _then(_WinnerChoiceArgs(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      possibleWinners: null == possibleWinners
          ? _self.possibleWinners
          : possibleWinners // ignore: cast_nullable_to_non_nullable
              as List<PossibleWinnerItem>,
    ));
  }
}

// dart format on
