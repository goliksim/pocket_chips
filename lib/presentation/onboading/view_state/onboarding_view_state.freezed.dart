// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingViewState {
  String get version;
  bool get isFirstLaunch;

  /// Create a copy of OnboardingViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardingViewStateCopyWith<OnboardingViewState> get copyWith =>
      _$OnboardingViewStateCopyWithImpl<OnboardingViewState>(
          this as OnboardingViewState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardingViewState &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isFirstLaunch, isFirstLaunch) ||
                other.isFirstLaunch == isFirstLaunch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, isFirstLaunch);

  @override
  String toString() {
    return 'OnboardingViewState(version: $version, isFirstLaunch: $isFirstLaunch)';
  }
}

/// @nodoc
abstract mixin class $OnboardingViewStateCopyWith<$Res> {
  factory $OnboardingViewStateCopyWith(
          OnboardingViewState value, $Res Function(OnboardingViewState) _then) =
      _$OnboardingViewStateCopyWithImpl;
  @useResult
  $Res call({String version, bool isFirstLaunch});
}

/// @nodoc
class _$OnboardingViewStateCopyWithImpl<$Res>
    implements $OnboardingViewStateCopyWith<$Res> {
  _$OnboardingViewStateCopyWithImpl(this._self, this._then);

  final OnboardingViewState _self;
  final $Res Function(OnboardingViewState) _then;

  /// Create a copy of OnboardingViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? isFirstLaunch = null,
  }) {
    return _then(_self.copyWith(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      isFirstLaunch: null == isFirstLaunch
          ? _self.isFirstLaunch
          : isFirstLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [OnboardingViewState].
extension OnboardingViewStatePatterns on OnboardingViewState {
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
    TResult Function(_OnboardingViewState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState() when $default != null:
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
    TResult Function(_OnboardingViewState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState():
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
    TResult? Function(_OnboardingViewState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState() when $default != null:
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
    TResult Function(String version, bool isFirstLaunch)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState() when $default != null:
        return $default(_that.version, _that.isFirstLaunch);
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
    TResult Function(String version, bool isFirstLaunch) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState():
        return $default(_that.version, _that.isFirstLaunch);
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
    TResult? Function(String version, bool isFirstLaunch)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OnboardingViewState() when $default != null:
        return $default(_that.version, _that.isFirstLaunch);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OnboardingViewState implements OnboardingViewState {
  const _OnboardingViewState(
      {required this.version, required this.isFirstLaunch});

  @override
  final String version;
  @override
  final bool isFirstLaunch;

  /// Create a copy of OnboardingViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OnboardingViewStateCopyWith<_OnboardingViewState> get copyWith =>
      __$OnboardingViewStateCopyWithImpl<_OnboardingViewState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OnboardingViewState &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.isFirstLaunch, isFirstLaunch) ||
                other.isFirstLaunch == isFirstLaunch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version, isFirstLaunch);

  @override
  String toString() {
    return 'OnboardingViewState(version: $version, isFirstLaunch: $isFirstLaunch)';
  }
}

/// @nodoc
abstract mixin class _$OnboardingViewStateCopyWith<$Res>
    implements $OnboardingViewStateCopyWith<$Res> {
  factory _$OnboardingViewStateCopyWith(_OnboardingViewState value,
          $Res Function(_OnboardingViewState) _then) =
      __$OnboardingViewStateCopyWithImpl;
  @override
  @useResult
  $Res call({String version, bool isFirstLaunch});
}

/// @nodoc
class __$OnboardingViewStateCopyWithImpl<$Res>
    implements _$OnboardingViewStateCopyWith<$Res> {
  __$OnboardingViewStateCopyWithImpl(this._self, this._then);

  final _OnboardingViewState _self;
  final $Res Function(_OnboardingViewState) _then;

  /// Create a copy of OnboardingViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? version = null,
    Object? isFirstLaunch = null,
  }) {
    return _then(_OnboardingViewState(
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      isFirstLaunch: null == isFirstLaunch
          ? _self.isFirstLaunch
          : isFirstLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
