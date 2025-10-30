// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerModel {
  PlayerId get uid;
  String get name;
  String get assetUrl;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      _$PlayerModelCopyWithImpl<PlayerModel>(this as PlayerModel, _$identity);

  @override
  String toString() {
    return 'PlayerModel(uid: $uid, name: $name, assetUrl: $assetUrl)';
  }
}

/// @nodoc
abstract mixin class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
          PlayerModel value, $Res Function(PlayerModel) _then) =
      _$PlayerModelCopyWithImpl;
  @useResult
  $Res call({PlayerId uid, String name, String assetUrl});
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res> implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._self, this._then);

  final PlayerModel _self;
  final $Res Function(PlayerModel) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as PlayerId,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlayerModel].
extension PlayerModelPatterns on PlayerModel {
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
    TResult Function(_PlayerModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerModel() when $default != null:
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
    TResult Function(_PlayerModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerModel():
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
    TResult? Function(_PlayerModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerModel() when $default != null:
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
    TResult Function(PlayerId uid, String name, String assetUrl)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlayerModel() when $default != null:
        return $default(_that.uid, _that.name, _that.assetUrl);
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
    TResult Function(PlayerId uid, String name, String assetUrl) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerModel():
        return $default(_that.uid, _that.name, _that.assetUrl);
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
    TResult? Function(PlayerId uid, String name, String assetUrl)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlayerModel() when $default != null:
        return $default(_that.uid, _that.name, _that.assetUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlayerModel extends PlayerModel {
  const _PlayerModel(
      {required this.uid, required this.name, required this.assetUrl})
      : super._();

  @override
  final PlayerId uid;
  @override
  final String name;
  @override
  final String assetUrl;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlayerModelCopyWith<_PlayerModel> get copyWith =>
      __$PlayerModelCopyWithImpl<_PlayerModel>(this, _$identity);

  @override
  String toString() {
    return 'PlayerModel(uid: $uid, name: $name, assetUrl: $assetUrl)';
  }
}

/// @nodoc
abstract mixin class _$PlayerModelCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$PlayerModelCopyWith(
          _PlayerModel value, $Res Function(_PlayerModel) _then) =
      __$PlayerModelCopyWithImpl;
  @override
  @useResult
  $Res call({PlayerId uid, String name, String assetUrl});
}

/// @nodoc
class __$PlayerModelCopyWithImpl<$Res> implements _$PlayerModelCopyWith<$Res> {
  __$PlayerModelCopyWithImpl(this._self, this._then);

  final _PlayerModel _self;
  final $Res Function(_PlayerModel) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
  }) {
    return _then(_PlayerModel(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as PlayerId,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
