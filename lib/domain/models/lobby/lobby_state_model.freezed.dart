// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobbyStateModel {
  List<PlayerModel> get players;
  Map<String, int> get banks;
  int get smallBlindValue;
  GameStatusEnum get gameState;
  int get defaultBank;
  String? get dealerId;

  /// Create a copy of LobbyStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LobbyStateModelCopyWith<LobbyStateModel> get copyWith =>
      _$LobbyStateModelCopyWithImpl<LobbyStateModel>(
          this as LobbyStateModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LobbyStateModel &&
            const DeepCollectionEquality().equals(other.players, players) &&
            const DeepCollectionEquality().equals(other.banks, banks) &&
            (identical(other.smallBlindValue, smallBlindValue) ||
                other.smallBlindValue == smallBlindValue) &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            (identical(other.defaultBank, defaultBank) ||
                other.defaultBank == defaultBank) &&
            (identical(other.dealerId, dealerId) ||
                other.dealerId == dealerId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      const DeepCollectionEquality().hash(banks),
      smallBlindValue,
      gameState,
      defaultBank,
      dealerId);

  @override
  String toString() {
    return 'LobbyStateModel(players: $players, banks: $banks, smallBlindValue: $smallBlindValue, gameState: $gameState, defaultBank: $defaultBank, dealerId: $dealerId)';
  }
}

/// @nodoc
abstract mixin class $LobbyStateModelCopyWith<$Res> {
  factory $LobbyStateModelCopyWith(
          LobbyStateModel value, $Res Function(LobbyStateModel) _then) =
      _$LobbyStateModelCopyWithImpl;
  @useResult
  $Res call(
      {List<PlayerModel> players,
      Map<String, int> banks,
      int smallBlindValue,
      GameStatusEnum gameState,
      int defaultBank,
      String? dealerId});
}

/// @nodoc
class _$LobbyStateModelCopyWithImpl<$Res>
    implements $LobbyStateModelCopyWith<$Res> {
  _$LobbyStateModelCopyWithImpl(this._self, this._then);

  final LobbyStateModel _self;
  final $Res Function(LobbyStateModel) _then;

  /// Create a copy of LobbyStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? banks = null,
    Object? smallBlindValue = null,
    Object? gameState = null,
    Object? defaultBank = null,
    Object? dealerId = freezed,
  }) {
    return _then(_self.copyWith(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<PlayerModel>,
      banks: null == banks
          ? _self.banks
          : banks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      smallBlindValue: null == smallBlindValue
          ? _self.smallBlindValue
          : smallBlindValue // ignore: cast_nullable_to_non_nullable
              as int,
      gameState: null == gameState
          ? _self.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameStatusEnum,
      defaultBank: null == defaultBank
          ? _self.defaultBank
          : defaultBank // ignore: cast_nullable_to_non_nullable
              as int,
      dealerId: freezed == dealerId
          ? _self.dealerId
          : dealerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LobbyStateModel].
extension LobbyStateModelPatterns on LobbyStateModel {
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
    TResult Function(_LobbyStateModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel() when $default != null:
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
    TResult Function(_LobbyStateModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel():
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
    TResult? Function(_LobbyStateModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel() when $default != null:
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
            List<PlayerModel> players,
            Map<String, int> banks,
            int smallBlindValue,
            GameStatusEnum gameState,
            int defaultBank,
            String? dealerId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel() when $default != null:
        return $default(_that.players, _that.banks, _that.smallBlindValue,
            _that.gameState, _that.defaultBank, _that.dealerId);
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
            List<PlayerModel> players,
            Map<String, int> banks,
            int smallBlindValue,
            GameStatusEnum gameState,
            int defaultBank,
            String? dealerId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel():
        return $default(_that.players, _that.banks, _that.smallBlindValue,
            _that.gameState, _that.defaultBank, _that.dealerId);
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
            List<PlayerModel> players,
            Map<String, int> banks,
            int smallBlindValue,
            GameStatusEnum gameState,
            int defaultBank,
            String? dealerId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LobbyStateModel() when $default != null:
        return $default(_that.players, _that.banks, _that.smallBlindValue,
            _that.gameState, _that.defaultBank, _that.dealerId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LobbyStateModel implements LobbyStateModel {
  const _LobbyStateModel(
      {required this.players,
      required this.banks,
      this.smallBlindValue = defaultSmallBlindValue,
      this.gameState = GameStatusEnum.notStarted,
      this.defaultBank = defaultLobbyBank,
      this.dealerId});

  @override
  final List<PlayerModel> players;
  @override
  final Map<String, int> banks;
  @override
  @JsonKey()
  final int smallBlindValue;
  @override
  @JsonKey()
  final GameStatusEnum gameState;
  @override
  @JsonKey()
  final int defaultBank;
  @override
  final String? dealerId;

  /// Create a copy of LobbyStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LobbyStateModelCopyWith<_LobbyStateModel> get copyWith =>
      __$LobbyStateModelCopyWithImpl<_LobbyStateModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LobbyStateModel &&
            const DeepCollectionEquality().equals(other.players, players) &&
            const DeepCollectionEquality().equals(other.banks, banks) &&
            (identical(other.smallBlindValue, smallBlindValue) ||
                other.smallBlindValue == smallBlindValue) &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            (identical(other.defaultBank, defaultBank) ||
                other.defaultBank == defaultBank) &&
            (identical(other.dealerId, dealerId) ||
                other.dealerId == dealerId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(players),
      const DeepCollectionEquality().hash(banks),
      smallBlindValue,
      gameState,
      defaultBank,
      dealerId);

  @override
  String toString() {
    return 'LobbyStateModel(players: $players, banks: $banks, smallBlindValue: $smallBlindValue, gameState: $gameState, defaultBank: $defaultBank, dealerId: $dealerId)';
  }
}

/// @nodoc
abstract mixin class _$LobbyStateModelCopyWith<$Res>
    implements $LobbyStateModelCopyWith<$Res> {
  factory _$LobbyStateModelCopyWith(
          _LobbyStateModel value, $Res Function(_LobbyStateModel) _then) =
      __$LobbyStateModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PlayerModel> players,
      Map<String, int> banks,
      int smallBlindValue,
      GameStatusEnum gameState,
      int defaultBank,
      String? dealerId});
}

/// @nodoc
class __$LobbyStateModelCopyWithImpl<$Res>
    implements _$LobbyStateModelCopyWith<$Res> {
  __$LobbyStateModelCopyWithImpl(this._self, this._then);

  final _LobbyStateModel _self;
  final $Res Function(_LobbyStateModel) _then;

  /// Create a copy of LobbyStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? players = null,
    Object? banks = null,
    Object? smallBlindValue = null,
    Object? gameState = null,
    Object? defaultBank = null,
    Object? dealerId = freezed,
  }) {
    return _then(_LobbyStateModel(
      players: null == players
          ? _self.players
          : players // ignore: cast_nullable_to_non_nullable
              as List<PlayerModel>,
      banks: null == banks
          ? _self.banks
          : banks // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      smallBlindValue: null == smallBlindValue
          ? _self.smallBlindValue
          : smallBlindValue // ignore: cast_nullable_to_non_nullable
              as int,
      gameState: null == gameState
          ? _self.gameState
          : gameState // ignore: cast_nullable_to_non_nullable
              as GameStatusEnum,
      defaultBank: null == defaultBank
          ? _self.defaultBank
          : defaultBank // ignore: cast_nullable_to_non_nullable
              as int,
      dealerId: freezed == dealerId
          ? _self.dealerId
          : dealerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
