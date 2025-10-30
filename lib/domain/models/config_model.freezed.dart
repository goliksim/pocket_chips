// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConfigModel {
  bool get isDark;
  bool get firstLaunch;
  String get locale;
  String get version;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigModelCopyWith<ConfigModel> get copyWith =>
      _$ConfigModelCopyWithImpl<ConfigModel>(this as ConfigModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfigModel &&
            (identical(other.isDark, isDark) || other.isDark == isDark) &&
            (identical(other.firstLaunch, firstLaunch) ||
                other.firstLaunch == firstLaunch) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isDark, firstLaunch, locale, version);

  @override
  String toString() {
    return 'ConfigModel(isDark: $isDark, firstLaunch: $firstLaunch, locale: $locale, version: $version)';
  }
}

/// @nodoc
abstract mixin class $ConfigModelCopyWith<$Res> {
  factory $ConfigModelCopyWith(
          ConfigModel value, $Res Function(ConfigModel) _then) =
      _$ConfigModelCopyWithImpl;
  @useResult
  $Res call({bool isDark, bool firstLaunch, String locale, String version});
}

/// @nodoc
class _$ConfigModelCopyWithImpl<$Res> implements $ConfigModelCopyWith<$Res> {
  _$ConfigModelCopyWithImpl(this._self, this._then);

  final ConfigModel _self;
  final $Res Function(ConfigModel) _then;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDark = null,
    Object? firstLaunch = null,
    Object? locale = null,
    Object? version = null,
  }) {
    return _then(_self.copyWith(
      isDark: null == isDark
          ? _self.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
      firstLaunch: null == firstLaunch
          ? _self.firstLaunch
          : firstLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      locale: null == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfigModel].
extension ConfigModelPatterns on ConfigModel {
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
    TResult Function(_ConfigModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigModel() when $default != null:
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
    TResult Function(_ConfigModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigModel():
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
    TResult? Function(_ConfigModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigModel() when $default != null:
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
            bool isDark, bool firstLaunch, String locale, String version)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigModel() when $default != null:
        return $default(
            _that.isDark, _that.firstLaunch, _that.locale, _that.version);
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
            bool isDark, bool firstLaunch, String locale, String version)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigModel():
        return $default(
            _that.isDark, _that.firstLaunch, _that.locale, _that.version);
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
            bool isDark, bool firstLaunch, String locale, String version)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigModel() when $default != null:
        return $default(
            _that.isDark, _that.firstLaunch, _that.locale, _that.version);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConfigModel implements ConfigModel {
  const _ConfigModel(
      {required this.isDark,
      required this.firstLaunch,
      required this.locale,
      required this.version});

  @override
  final bool isDark;
  @override
  final bool firstLaunch;
  @override
  final String locale;
  @override
  final String version;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfigModelCopyWith<_ConfigModel> get copyWith =>
      __$ConfigModelCopyWithImpl<_ConfigModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfigModel &&
            (identical(other.isDark, isDark) || other.isDark == isDark) &&
            (identical(other.firstLaunch, firstLaunch) ||
                other.firstLaunch == firstLaunch) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isDark, firstLaunch, locale, version);

  @override
  String toString() {
    return 'ConfigModel(isDark: $isDark, firstLaunch: $firstLaunch, locale: $locale, version: $version)';
  }
}

/// @nodoc
abstract mixin class _$ConfigModelCopyWith<$Res>
    implements $ConfigModelCopyWith<$Res> {
  factory _$ConfigModelCopyWith(
          _ConfigModel value, $Res Function(_ConfigModel) _then) =
      __$ConfigModelCopyWithImpl;
  @override
  @useResult
  $Res call({bool isDark, bool firstLaunch, String locale, String version});
}

/// @nodoc
class __$ConfigModelCopyWithImpl<$Res> implements _$ConfigModelCopyWith<$Res> {
  __$ConfigModelCopyWithImpl(this._self, this._then);

  final _ConfigModel _self;
  final $Res Function(_ConfigModel) _then;

  /// Create a copy of ConfigModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isDark = null,
    Object? firstLaunch = null,
    Object? locale = null,
    Object? version = null,
  }) {
    return _then(_ConfigModel(
      isDark: null == isDark
          ? _self.isDark
          : isDark // ignore: cast_nullable_to_non_nullable
              as bool,
      firstLaunch: null == firstLaunch
          ? _self.firstLaunch
          : firstLaunch // ignore: cast_nullable_to_non_nullable
              as bool,
      locale: null == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
