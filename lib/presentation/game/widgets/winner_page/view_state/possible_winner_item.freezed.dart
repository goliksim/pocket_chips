// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'possible_winner_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PossibleWinnerItem {
  String get uid;
  String get assetUrl;
  String get name;
  int get bid;

  /// Create a copy of PossibleWinnerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PossibleWinnerItemCopyWith<PossibleWinnerItem> get copyWith =>
      _$PossibleWinnerItemCopyWithImpl<PossibleWinnerItem>(
          this as PossibleWinnerItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PossibleWinnerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bid, bid) || other.bid == bid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, assetUrl, name, bid);

  @override
  String toString() {
    return 'PossibleWinnerItem(uid: $uid, assetUrl: $assetUrl, name: $name, bid: $bid)';
  }
}

/// @nodoc
abstract mixin class $PossibleWinnerItemCopyWith<$Res> {
  factory $PossibleWinnerItemCopyWith(
          PossibleWinnerItem value, $Res Function(PossibleWinnerItem) _then) =
      _$PossibleWinnerItemCopyWithImpl;
  @useResult
  $Res call({String uid, String assetUrl, String name, int bid});
}

/// @nodoc
class _$PossibleWinnerItemCopyWithImpl<$Res>
    implements $PossibleWinnerItemCopyWith<$Res> {
  _$PossibleWinnerItemCopyWithImpl(this._self, this._then);

  final PossibleWinnerItem _self;
  final $Res Function(PossibleWinnerItem) _then;

  /// Create a copy of PossibleWinnerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? assetUrl = null,
    Object? name = null,
    Object? bid = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bid: null == bid
          ? _self.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PossibleWinnerItem].
extension PossibleWinnerItemPatterns on PossibleWinnerItem {
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
    TResult Function(_PossibleWinnerItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem() when $default != null:
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
    TResult Function(_PossibleWinnerItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem():
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
    TResult? Function(_PossibleWinnerItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem() when $default != null:
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
    TResult Function(String uid, String assetUrl, String name, int bid)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem() when $default != null:
        return $default(_that.uid, _that.assetUrl, _that.name, _that.bid);
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
    TResult Function(String uid, String assetUrl, String name, int bid)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem():
        return $default(_that.uid, _that.assetUrl, _that.name, _that.bid);
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
    TResult? Function(String uid, String assetUrl, String name, int bid)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PossibleWinnerItem() when $default != null:
        return $default(_that.uid, _that.assetUrl, _that.name, _that.bid);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PossibleWinnerItem implements PossibleWinnerItem {
  const _PossibleWinnerItem(
      {required this.uid,
      required this.assetUrl,
      required this.name,
      required this.bid});

  @override
  final String uid;
  @override
  final String assetUrl;
  @override
  final String name;
  @override
  final int bid;

  /// Create a copy of PossibleWinnerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PossibleWinnerItemCopyWith<_PossibleWinnerItem> get copyWith =>
      __$PossibleWinnerItemCopyWithImpl<_PossibleWinnerItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PossibleWinnerItem &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.assetUrl, assetUrl) ||
                other.assetUrl == assetUrl) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bid, bid) || other.bid == bid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uid, assetUrl, name, bid);

  @override
  String toString() {
    return 'PossibleWinnerItem(uid: $uid, assetUrl: $assetUrl, name: $name, bid: $bid)';
  }
}

/// @nodoc
abstract mixin class _$PossibleWinnerItemCopyWith<$Res>
    implements $PossibleWinnerItemCopyWith<$Res> {
  factory _$PossibleWinnerItemCopyWith(
          _PossibleWinnerItem value, $Res Function(_PossibleWinnerItem) _then) =
      __$PossibleWinnerItemCopyWithImpl;
  @override
  @useResult
  $Res call({String uid, String assetUrl, String name, int bid});
}

/// @nodoc
class __$PossibleWinnerItemCopyWithImpl<$Res>
    implements _$PossibleWinnerItemCopyWith<$Res> {
  __$PossibleWinnerItemCopyWithImpl(this._self, this._then);

  final _PossibleWinnerItem _self;
  final $Res Function(_PossibleWinnerItem) _then;

  /// Create a copy of PossibleWinnerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? assetUrl = null,
    Object? name = null,
    Object? bid = null,
  }) {
    return _then(_PossibleWinnerItem(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      assetUrl: null == assetUrl
          ? _self.assetUrl
          : assetUrl // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bid: null == bid
          ? _self.bid
          : bid // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
