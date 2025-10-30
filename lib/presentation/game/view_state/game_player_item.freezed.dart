// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_player_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamePlayerItem {
  String get uid;
  String get name;
  String get assetUrl;
  bool get isDealer;
  bool get isCurrent;
  bool get isFolded;
  int? get bank;
  int? get bet;

  /// Create a copy of GamePlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GamePlayerItemCopyWith<GamePlayerItem> get copyWith =>
      _$GamePlayerItemCopyWithImpl<GamePlayerItem>(
          this as GamePlayerItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GamePlayerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.isDealer, isDealer) ||
                other.isDealer == isDealer) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.isFolded, isFolded) ||
                other.isFolded == isFolded) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.bet, bet) || other.bet == bet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, name, assetUrl, isDealer,
      isCurrent, isFolded, bank, bet);

  @override
  String toString() {
    return 'GamePlayerItem(uid: $uid, name: $name, assetUrl: $assetUrl, isDealer: $isDealer, isCurrent: $isCurrent, isFolded: $isFolded, bank: $bank, bet: $bet)';
  }
}

/// @nodoc
abstract mixin class $GamePlayerItemCopyWith<$Res> {
  factory $GamePlayerItemCopyWith(
          GamePlayerItem value, $Res Function(GamePlayerItem) _then) =
      _$GamePlayerItemCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String name,
      String assetUrl,
      bool isDealer,
      bool isCurrent,
      bool isFolded,
      int? bank,
      int? bet});
}

/// @nodoc
class _$GamePlayerItemCopyWithImpl<$Res>
    implements $GamePlayerItemCopyWith<$Res> {
  _$GamePlayerItemCopyWithImpl(this._self, this._then);

  final GamePlayerItem _self;
  final $Res Function(GamePlayerItem) _then;

  /// Create a copy of GamePlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
    Object? isDealer = null,
    Object? isCurrent = null,
    Object? isFolded = null,
    Object? bank = freezed,
    Object? bet = freezed,
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
      isCurrent: null == isCurrent
          ? _self.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isFolded: null == isFolded
          ? _self.isFolded
          : isFolded // ignore: cast_nullable_to_non_nullable
              as bool,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as int?,
      bet: freezed == bet
          ? _self.bet
          : bet // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GamePlayerItem].
extension GamePlayerItemPatterns on GamePlayerItem {
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
    TResult Function(_GamePlayerItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem() when $default != null:
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
    TResult Function(_GamePlayerItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem():
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
    TResult? Function(_GamePlayerItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem() when $default != null:
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
    TResult Function(String uid, String name, String assetUrl, bool isDealer,
            bool isCurrent, bool isFolded, int? bank, int? bet)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem() when $default != null:
        return $default(_that.uid, _that.name, _that.assetUrl, _that.isDealer,
            _that.isCurrent, _that.isFolded, _that.bank, _that.bet);
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
    TResult Function(String uid, String name, String assetUrl, bool isDealer,
            bool isCurrent, bool isFolded, int? bank, int? bet)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem():
        return $default(_that.uid, _that.name, _that.assetUrl, _that.isDealer,
            _that.isCurrent, _that.isFolded, _that.bank, _that.bet);
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
    TResult? Function(String uid, String name, String assetUrl, bool isDealer,
            bool isCurrent, bool isFolded, int? bank, int? bet)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamePlayerItem() when $default != null:
        return $default(_that.uid, _that.name, _that.assetUrl, _that.isDealer,
            _that.isCurrent, _that.isFolded, _that.bank, _that.bet);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _GamePlayerItem implements GamePlayerItem {
  const _GamePlayerItem(
      {required this.uid,
      required this.name,
      required this.assetUrl,
      required this.isDealer,
      required this.isCurrent,
      required this.isFolded,
      this.bank,
      this.bet});

  @override
  final String uid;
  @override
  final String name;
  @override
  final String assetUrl;
  @override
  final bool isDealer;
  @override
  final bool isCurrent;
  @override
  final bool isFolded;
  @override
  final int? bank;
  @override
  final int? bet;

  /// Create a copy of GamePlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GamePlayerItemCopyWith<_GamePlayerItem> get copyWith =>
      __$GamePlayerItemCopyWithImpl<_GamePlayerItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GamePlayerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.isDealer, isDealer) ||
                other.isDealer == isDealer) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.isFolded, isFolded) ||
                other.isFolded == isFolded) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.bet, bet) || other.bet == bet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, name, assetUrl, isDealer,
      isCurrent, isFolded, bank, bet);

  @override
  String toString() {
    return 'GamePlayerItem(uid: $uid, name: $name, assetUrl: $assetUrl, isDealer: $isDealer, isCurrent: $isCurrent, isFolded: $isFolded, bank: $bank, bet: $bet)';
  }
}

/// @nodoc
abstract mixin class _$GamePlayerItemCopyWith<$Res>
    implements $GamePlayerItemCopyWith<$Res> {
  factory _$GamePlayerItemCopyWith(
          _GamePlayerItem value, $Res Function(_GamePlayerItem) _then) =
      __$GamePlayerItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String name,
      String assetUrl,
      bool isDealer,
      bool isCurrent,
      bool isFolded,
      int? bank,
      int? bet});
}

/// @nodoc
class __$GamePlayerItemCopyWithImpl<$Res>
    implements _$GamePlayerItemCopyWith<$Res> {
  __$GamePlayerItemCopyWithImpl(this._self, this._then);

  final _GamePlayerItem _self;
  final $Res Function(_GamePlayerItem) _then;

  /// Create a copy of GamePlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? name = null,
    Object? assetUrl = null,
    Object? isDealer = null,
    Object? isCurrent = null,
    Object? isFolded = null,
    Object? bank = freezed,
    Object? bet = freezed,
  }) {
    return _then(_GamePlayerItem(
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
      isCurrent: null == isCurrent
          ? _self.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      isFolded: null == isFolded
          ? _self.isFolded
          : isFolded // ignore: cast_nullable_to_non_nullable
              as bool,
      bank: freezed == bank
          ? _self.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as int?,
      bet: freezed == bet
          ? _self.bet
          : bet // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
