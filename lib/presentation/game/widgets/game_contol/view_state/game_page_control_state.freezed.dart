// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_page_control_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamePageControlState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GamePageControlState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GamePageControlState()';
  }
}

/// @nodoc
class $GamePageControlStateCopyWith<$Res> {
  $GamePageControlStateCopyWith(
      GamePageControlState _, $Res Function(GamePageControlState) __);
}

/// Adds pattern-matching-related methods to [GamePageControlState].
extension GamePageControlStatePatterns on GamePageControlState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GamePageActiveControlState value)? active,
    TResult Function(_GamePageControlState value)? breakdown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState() when active != null:
        return active(_that);
      case _GamePageControlState() when breakdown != null:
        return breakdown(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(GamePageActiveControlState value) active,
    required TResult Function(_GamePageControlState value) breakdown,
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState():
        return active(_that);
      case _GamePageControlState():
        return breakdown(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GamePageActiveControlState value)? active,
    TResult? Function(_GamePageControlState value)? breakdown,
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState() when active != null:
        return active(_that);
      case _GamePageControlState() when breakdown != null:
        return breakdown(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(RaiseControlState raiseState, MainControlState mainState)?
        active,
    TResult Function(bool canStartBetting)? breakdown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState() when active != null:
        return active(_that.raiseState, _that.mainState);
      case _GamePageControlState() when breakdown != null:
        return breakdown(_that.canStartBetting);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            RaiseControlState raiseState, MainControlState mainState)
        active,
    required TResult Function(bool canStartBetting) breakdown,
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState():
        return active(_that.raiseState, _that.mainState);
      case _GamePageControlState():
        return breakdown(_that.canStartBetting);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(RaiseControlState raiseState, MainControlState mainState)?
        active,
    TResult? Function(bool canStartBetting)? breakdown,
  }) {
    final _that = this;
    switch (_that) {
      case GamePageActiveControlState() when active != null:
        return active(_that.raiseState, _that.mainState);
      case _GamePageControlState() when breakdown != null:
        return breakdown(_that.canStartBetting);
      case _:
        return null;
    }
  }
}

/// @nodoc

class GamePageActiveControlState implements GamePageControlState {
  const GamePageActiveControlState(
      {required this.raiseState, required this.mainState});

  final RaiseControlState raiseState;
  final MainControlState mainState;

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GamePageActiveControlStateCopyWith<GamePageActiveControlState>
      get copyWith =>
          _$GamePageActiveControlStateCopyWithImpl<GamePageActiveControlState>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GamePageActiveControlState &&
            (identical(other.raiseState, raiseState) ||
                other.raiseState == raiseState) &&
            (identical(other.mainState, mainState) ||
                other.mainState == mainState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, raiseState, mainState);

  @override
  String toString() {
    return 'GamePageControlState.active(raiseState: $raiseState, mainState: $mainState)';
  }
}

/// @nodoc
abstract mixin class $GamePageActiveControlStateCopyWith<$Res>
    implements $GamePageControlStateCopyWith<$Res> {
  factory $GamePageActiveControlStateCopyWith(GamePageActiveControlState value,
          $Res Function(GamePageActiveControlState) _then) =
      _$GamePageActiveControlStateCopyWithImpl;
  @useResult
  $Res call({RaiseControlState raiseState, MainControlState mainState});

  $RaiseControlStateCopyWith<$Res> get raiseState;
  $MainControlStateCopyWith<$Res> get mainState;
}

/// @nodoc
class _$GamePageActiveControlStateCopyWithImpl<$Res>
    implements $GamePageActiveControlStateCopyWith<$Res> {
  _$GamePageActiveControlStateCopyWithImpl(this._self, this._then);

  final GamePageActiveControlState _self;
  final $Res Function(GamePageActiveControlState) _then;

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? raiseState = null,
    Object? mainState = null,
  }) {
    return _then(GamePageActiveControlState(
      raiseState: null == raiseState
          ? _self.raiseState
          : raiseState // ignore: cast_nullable_to_non_nullable
              as RaiseControlState,
      mainState: null == mainState
          ? _self.mainState
          : mainState // ignore: cast_nullable_to_non_nullable
              as MainControlState,
    ));
  }

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RaiseControlStateCopyWith<$Res> get raiseState {
    return $RaiseControlStateCopyWith<$Res>(_self.raiseState, (value) {
      return _then(_self.copyWith(raiseState: value));
    });
  }

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MainControlStateCopyWith<$Res> get mainState {
    return $MainControlStateCopyWith<$Res>(_self.mainState, (value) {
      return _then(_self.copyWith(mainState: value));
    });
  }
}

/// @nodoc

class _GamePageControlState implements GamePageControlState {
  const _GamePageControlState({required this.canStartBetting});

  final bool canStartBetting;

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GamePageControlStateCopyWith<_GamePageControlState> get copyWith =>
      __$GamePageControlStateCopyWithImpl<_GamePageControlState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GamePageControlState &&
            (identical(other.canStartBetting, canStartBetting) ||
                other.canStartBetting == canStartBetting));
  }

  @override
  int get hashCode => Object.hash(runtimeType, canStartBetting);

  @override
  String toString() {
    return 'GamePageControlState.breakdown(canStartBetting: $canStartBetting)';
  }
}

/// @nodoc
abstract mixin class _$GamePageControlStateCopyWith<$Res>
    implements $GamePageControlStateCopyWith<$Res> {
  factory _$GamePageControlStateCopyWith(_GamePageControlState value,
          $Res Function(_GamePageControlState) _then) =
      __$GamePageControlStateCopyWithImpl;
  @useResult
  $Res call({bool canStartBetting});
}

/// @nodoc
class __$GamePageControlStateCopyWithImpl<$Res>
    implements _$GamePageControlStateCopyWith<$Res> {
  __$GamePageControlStateCopyWithImpl(this._self, this._then);

  final _GamePageControlState _self;
  final $Res Function(_GamePageControlState) _then;

  /// Create a copy of GamePageControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? canStartBetting = null,
  }) {
    return _then(_GamePageControlState(
      canStartBetting: null == canStartBetting
          ? _self.canStartBetting
          : canStartBetting // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$RaiseControlState {
  bool get canRaise;
  bool get onlyAllInRaise;
  bool get isFirstBet;
  int get maxPossibleBet;
  int get minPossibleBet;

  /// Create a copy of RaiseControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RaiseControlStateCopyWith<RaiseControlState> get copyWith =>
      _$RaiseControlStateCopyWithImpl<RaiseControlState>(
          this as RaiseControlState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RaiseControlState &&
            (identical(other.canRaise, canRaise) ||
                other.canRaise == canRaise) &&
            (identical(other.onlyAllInRaise, onlyAllInRaise) ||
                other.onlyAllInRaise == onlyAllInRaise) &&
            (identical(other.isFirstBet, isFirstBet) ||
                other.isFirstBet == isFirstBet) &&
            (identical(other.maxPossibleBet, maxPossibleBet) ||
                other.maxPossibleBet == maxPossibleBet) &&
            (identical(other.minPossibleBet, minPossibleBet) ||
                other.minPossibleBet == minPossibleBet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, canRaise, onlyAllInRaise,
      isFirstBet, maxPossibleBet, minPossibleBet);

  @override
  String toString() {
    return 'RaiseControlState(canRaise: $canRaise, onlyAllInRaise: $onlyAllInRaise, isFirstBet: $isFirstBet, maxPossibleBet: $maxPossibleBet, minPossibleBet: $minPossibleBet)';
  }
}

/// @nodoc
abstract mixin class $RaiseControlStateCopyWith<$Res> {
  factory $RaiseControlStateCopyWith(
          RaiseControlState value, $Res Function(RaiseControlState) _then) =
      _$RaiseControlStateCopyWithImpl;
  @useResult
  $Res call(
      {bool canRaise,
      bool onlyAllInRaise,
      bool isFirstBet,
      int maxPossibleBet,
      int minPossibleBet});
}

/// @nodoc
class _$RaiseControlStateCopyWithImpl<$Res>
    implements $RaiseControlStateCopyWith<$Res> {
  _$RaiseControlStateCopyWithImpl(this._self, this._then);

  final RaiseControlState _self;
  final $Res Function(RaiseControlState) _then;

  /// Create a copy of RaiseControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canRaise = null,
    Object? onlyAllInRaise = null,
    Object? isFirstBet = null,
    Object? maxPossibleBet = null,
    Object? minPossibleBet = null,
  }) {
    return _then(_self.copyWith(
      canRaise: null == canRaise
          ? _self.canRaise
          : canRaise // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAllInRaise: null == onlyAllInRaise
          ? _self.onlyAllInRaise
          : onlyAllInRaise // ignore: cast_nullable_to_non_nullable
              as bool,
      isFirstBet: null == isFirstBet
          ? _self.isFirstBet
          : isFirstBet // ignore: cast_nullable_to_non_nullable
              as bool,
      maxPossibleBet: null == maxPossibleBet
          ? _self.maxPossibleBet
          : maxPossibleBet // ignore: cast_nullable_to_non_nullable
              as int,
      minPossibleBet: null == minPossibleBet
          ? _self.minPossibleBet
          : minPossibleBet // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [RaiseControlState].
extension RaiseControlStatePatterns on RaiseControlState {
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
    TResult Function(_RaiseControlState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState() when $default != null:
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
    TResult Function(_RaiseControlState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState():
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
    TResult? Function(_RaiseControlState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState() when $default != null:
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
    TResult Function(bool canRaise, bool onlyAllInRaise, bool isFirstBet,
            int maxPossibleBet, int minPossibleBet)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState() when $default != null:
        return $default(_that.canRaise, _that.onlyAllInRaise, _that.isFirstBet,
            _that.maxPossibleBet, _that.minPossibleBet);
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
    TResult Function(bool canRaise, bool onlyAllInRaise, bool isFirstBet,
            int maxPossibleBet, int minPossibleBet)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState():
        return $default(_that.canRaise, _that.onlyAllInRaise, _that.isFirstBet,
            _that.maxPossibleBet, _that.minPossibleBet);
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
    TResult? Function(bool canRaise, bool onlyAllInRaise, bool isFirstBet,
            int maxPossibleBet, int minPossibleBet)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RaiseControlState() when $default != null:
        return $default(_that.canRaise, _that.onlyAllInRaise, _that.isFirstBet,
            _that.maxPossibleBet, _that.minPossibleBet);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RaiseControlState implements RaiseControlState {
  const _RaiseControlState(
      {required this.canRaise,
      required this.onlyAllInRaise,
      required this.isFirstBet,
      required this.maxPossibleBet,
      required this.minPossibleBet});

  @override
  final bool canRaise;
  @override
  final bool onlyAllInRaise;
  @override
  final bool isFirstBet;
  @override
  final int maxPossibleBet;
  @override
  final int minPossibleBet;

  /// Create a copy of RaiseControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RaiseControlStateCopyWith<_RaiseControlState> get copyWith =>
      __$RaiseControlStateCopyWithImpl<_RaiseControlState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RaiseControlState &&
            (identical(other.canRaise, canRaise) ||
                other.canRaise == canRaise) &&
            (identical(other.onlyAllInRaise, onlyAllInRaise) ||
                other.onlyAllInRaise == onlyAllInRaise) &&
            (identical(other.isFirstBet, isFirstBet) ||
                other.isFirstBet == isFirstBet) &&
            (identical(other.maxPossibleBet, maxPossibleBet) ||
                other.maxPossibleBet == maxPossibleBet) &&
            (identical(other.minPossibleBet, minPossibleBet) ||
                other.minPossibleBet == minPossibleBet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, canRaise, onlyAllInRaise,
      isFirstBet, maxPossibleBet, minPossibleBet);

  @override
  String toString() {
    return 'RaiseControlState(canRaise: $canRaise, onlyAllInRaise: $onlyAllInRaise, isFirstBet: $isFirstBet, maxPossibleBet: $maxPossibleBet, minPossibleBet: $minPossibleBet)';
  }
}

/// @nodoc
abstract mixin class _$RaiseControlStateCopyWith<$Res>
    implements $RaiseControlStateCopyWith<$Res> {
  factory _$RaiseControlStateCopyWith(
          _RaiseControlState value, $Res Function(_RaiseControlState) _then) =
      __$RaiseControlStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool canRaise,
      bool onlyAllInRaise,
      bool isFirstBet,
      int maxPossibleBet,
      int minPossibleBet});
}

/// @nodoc
class __$RaiseControlStateCopyWithImpl<$Res>
    implements _$RaiseControlStateCopyWith<$Res> {
  __$RaiseControlStateCopyWithImpl(this._self, this._then);

  final _RaiseControlState _self;
  final $Res Function(_RaiseControlState) _then;

  /// Create a copy of RaiseControlState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? canRaise = null,
    Object? onlyAllInRaise = null,
    Object? isFirstBet = null,
    Object? maxPossibleBet = null,
    Object? minPossibleBet = null,
  }) {
    return _then(_RaiseControlState(
      canRaise: null == canRaise
          ? _self.canRaise
          : canRaise // ignore: cast_nullable_to_non_nullable
              as bool,
      onlyAllInRaise: null == onlyAllInRaise
          ? _self.onlyAllInRaise
          : onlyAllInRaise // ignore: cast_nullable_to_non_nullable
              as bool,
      isFirstBet: null == isFirstBet
          ? _self.isFirstBet
          : isFirstBet // ignore: cast_nullable_to_non_nullable
              as bool,
      maxPossibleBet: null == maxPossibleBet
          ? _self.maxPossibleBet
          : maxPossibleBet // ignore: cast_nullable_to_non_nullable
              as int,
      minPossibleBet: null == minPossibleBet
          ? _self.minPossibleBet
          : minPossibleBet // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$MainControlState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MainControlState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MainControlState()';
  }
}

/// @nodoc
class $MainControlStateCopyWith<$Res> {
  $MainControlStateCopyWith(
      MainControlState _, $Res Function(MainControlState) __);
}

/// Adds pattern-matching-related methods to [MainControlState].
extension MainControlStatePatterns on MainControlState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_MainControlCheckState value)? check,
    TResult Function(_MainControlCallState value)? call,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState() when check != null:
        return check(_that);
      case _MainControlCallState() when call != null:
        return call(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(_MainControlCheckState value) check,
    required TResult Function(_MainControlCallState value) call,
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState():
        return check(_that);
      case _MainControlCallState():
        return call(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_MainControlCheckState value)? check,
    TResult? Function(_MainControlCallState value)? call,
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState() when check != null:
        return check(_that);
      case _MainControlCallState() when call != null:
        return call(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? check,
    TResult Function(bool callIsAllIn, int callValue)? call,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState() when check != null:
        return check();
      case _MainControlCallState() when call != null:
        return call(_that.callIsAllIn, _that.callValue);
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
  TResult when<TResult extends Object?>({
    required TResult Function() check,
    required TResult Function(bool callIsAllIn, int callValue) call,
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState():
        return check();
      case _MainControlCallState():
        return call(_that.callIsAllIn, _that.callValue);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? check,
    TResult? Function(bool callIsAllIn, int callValue)? call,
  }) {
    final _that = this;
    switch (_that) {
      case _MainControlCheckState() when check != null:
        return check();
      case _MainControlCallState() when call != null:
        return call(_that.callIsAllIn, _that.callValue);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MainControlCheckState extends MainControlState {
  const _MainControlCheckState() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _MainControlCheckState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MainControlState.check()';
  }
}

/// @nodoc

class _MainControlCallState extends MainControlState {
  const _MainControlCallState(
      {required this.callIsAllIn, required this.callValue})
      : super._();

  final bool callIsAllIn;
  final int callValue;

  /// Create a copy of MainControlState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MainControlCallStateCopyWith<_MainControlCallState> get copyWith =>
      __$MainControlCallStateCopyWithImpl<_MainControlCallState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MainControlCallState &&
            (identical(other.callIsAllIn, callIsAllIn) ||
                other.callIsAllIn == callIsAllIn) &&
            (identical(other.callValue, callValue) ||
                other.callValue == callValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, callIsAllIn, callValue);

  @override
  String toString() {
    return 'MainControlState.call(callIsAllIn: $callIsAllIn, callValue: $callValue)';
  }
}

/// @nodoc
abstract mixin class _$MainControlCallStateCopyWith<$Res>
    implements $MainControlStateCopyWith<$Res> {
  factory _$MainControlCallStateCopyWith(_MainControlCallState value,
          $Res Function(_MainControlCallState) _then) =
      __$MainControlCallStateCopyWithImpl;
  @useResult
  $Res call({bool callIsAllIn, int callValue});
}

/// @nodoc
class __$MainControlCallStateCopyWithImpl<$Res>
    implements _$MainControlCallStateCopyWith<$Res> {
  __$MainControlCallStateCopyWithImpl(this._self, this._then);

  final _MainControlCallState _self;
  final $Res Function(_MainControlCallState) _then;

  /// Create a copy of MainControlState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? callIsAllIn = null,
    Object? callValue = null,
  }) {
    return _then(_MainControlCallState(
      callIsAllIn: null == callIsAllIn
          ? _self.callIsAllIn
          : callIsAllIn // ignore: cast_nullable_to_non_nullable
              as bool,
      callValue: null == callValue
          ? _self.callValue
          : callValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
