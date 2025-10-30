// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_player_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobbyPlayerItem {
  String get uid;
  String get name;
  String get assetUrl;
  bool get isDealer;
  int? get bank;

  /// Create a copy of LobbyPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LobbyPlayerItemCopyWith<LobbyPlayerItem> get copyWith =>
      _$LobbyPlayerItemCopyWithImpl<LobbyPlayerItem>(
          this as LobbyPlayerItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LobbyPlayerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.isDealer, isDealer) ||
                other.isDealer == isDealer) &&
            (identical(other.bank, bank) || other.bank == bank));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, assetUrl, isDealer, bank);

  @override
  String toString() {
    return 'LobbyPlayerItem(uid: $uid, name: $name, assetUrl: $assetUrl, isDealer: $isDealer, bank: $bank)';
  }
}

/// @nodoc
abstract mixin class $LobbyPlayerItemCopyWith<$Res> {
  factory $LobbyPlayerItemCopyWith(
          LobbyPlayerItem value, $Res Function(LobbyPlayerItem) _then) =
      _$LobbyPlayerItemCopyWithImpl;
  @useResult
  $Res call(
      {String uid, String name, String assetUrl, bool isDealer, int? bank});
}

/// @nodoc
class _$LobbyPlayerItemCopyWithImpl<$Res>
    implements $LobbyPlayerItemCopyWith<$Res> {
  _$LobbyPlayerItemCopyWithImpl(this._self, this._then);

  final LobbyPlayerItem _self;
  final $Res Function(LobbyPlayerItem) _then;

  /// Create a copy of LobbyPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
    Object? isDealer = null,
    Object? bank = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isDealer: null == isDealer
          ? _self.isDealer
          : isDealer // ignore: cast_nullable_to_non_nullable
              as bool,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LobbyPlayerItem].
extension LobbyPlayerItemPatterns on LobbyPlayerItem {
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
    TResult Function(_LobbyPlayerItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem() when $default != null:
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
    TResult Function(_LobbyPlayerItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem():
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
    TResult? Function(_LobbyPlayerItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem() when $default != null:
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
            String uid, String name, String assetUrl, bool isDealer, int? bank)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem() when $default != null:
        return $default(
            _that.uid, _that.name, _that.assetUrl, _that.isDealer, _that.bank);
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
            String uid, String name, String assetUrl, bool isDealer, int? bank)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem():
        return $default(
            _that.uid, _that.name, _that.assetUrl, _that.isDealer, _that.bank);
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
            String uid, String name, String assetUrl, bool isDealer, int? bank)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyPlayerItem() when $default != null:
        return $default(
            _that.uid, _that.name, _that.assetUrl, _that.isDealer, _that.bank);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LobbyPlayerItem implements LobbyPlayerItem {
  const _LobbyPlayerItem(
      {required this.uid,
      required this.name,
      required this.assetUrl,
      this.isDealer = false,
      this.bank});

  @override
  final String uid;
  @override
  final String name;
  @override
  final String assetUrl;
  @override
  @JsonKey()
  final bool isDealer;
  @override
  final int? bank;

  /// Create a copy of LobbyPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LobbyPlayerItemCopyWith<_LobbyPlayerItem> get copyWith =>
      __$LobbyPlayerItemCopyWithImpl<_LobbyPlayerItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LobbyPlayerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.isDealer, isDealer) ||
                other.isDealer == isDealer) &&
            (identical(other.bank, bank) || other.bank == bank));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, uid, name, assetUrl, isDealer, bank);

  @override
  String toString() {
    return 'LobbyPlayerItem(uid: $uid, name: $name, assetUrl: $assetUrl, isDealer: $isDealer, bank: $bank)';
  }
}

/// @nodoc
abstract mixin class _$LobbyPlayerItemCopyWith<$Res>
    implements $LobbyPlayerItemCopyWith<$Res> {
  factory _$LobbyPlayerItemCopyWith(
          _LobbyPlayerItem value, $Res Function(_LobbyPlayerItem) _then) =
      __$LobbyPlayerItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid, String name, String assetUrl, bool isDealer, int? bank});
}

/// @nodoc
class __$LobbyPlayerItemCopyWithImpl<$Res>
    implements _$LobbyPlayerItemCopyWith<$Res> {
  __$LobbyPlayerItemCopyWithImpl(this._self, this._then);

  final _LobbyPlayerItem _self;
  final $Res Function(_LobbyPlayerItem) _then;

  /// Create a copy of LobbyPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
    Object? isDealer = null,
    Object? bank = freezed,
  }) {
    return _then(_LobbyPlayerItem(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isDealer: null == isDealer
          ? _self.isDealer
          : isDealer // ignore: cast_nullable_to_non_nullable
              as bool,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
