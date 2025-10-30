// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_control_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameControlResult {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is GameControlResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GameControlResult()';
  }
}

/// @nodoc
class $GameControlResultCopyWith<$Res> {
  $GameControlResultCopyWith(
      GameControlResult _, $Res Function(GameControlResult) __);
}

/// Adds pattern-matching-related methods to [GameControlResult].
extension GameControlResultPatterns on GameControlResult {
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
    TResult Function(GameControlRaiseResult value)? raise,
    TResult Function(_GameControlAllInResult value)? allIn,
    TResult Function(_GameControlCallResult value)? call,
    TResult Function(_GameControlCheckResult value)? check,
    TResult Function(_GameControlFoldResult value)? fold,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult() when raise != null:
        return raise(_that);
      case _GameControlAllInResult() when allIn != null:
        return allIn(_that);
      case _GameControlCallResult() when call != null:
        return call(_that);
      case _GameControlCheckResult() when check != null:
        return check(_that);
      case _GameControlFoldResult() when fold != null:
        return fold(_that);
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
    required TResult Function(GameControlRaiseResult value) raise,
    required TResult Function(_GameControlAllInResult value) allIn,
    required TResult Function(_GameControlCallResult value) call,
    required TResult Function(_GameControlCheckResult value) check,
    required TResult Function(_GameControlFoldResult value) fold,
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult():
        return raise(_that);
      case _GameControlAllInResult():
        return allIn(_that);
      case _GameControlCallResult():
        return call(_that);
      case _GameControlCheckResult():
        return check(_that);
      case _GameControlFoldResult():
        return fold(_that);
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
    TResult? Function(GameControlRaiseResult value)? raise,
    TResult? Function(_GameControlAllInResult value)? allIn,
    TResult? Function(_GameControlCallResult value)? call,
    TResult? Function(_GameControlCheckResult value)? check,
    TResult? Function(_GameControlFoldResult value)? fold,
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult() when raise != null:
        return raise(_that);
      case _GameControlAllInResult() when allIn != null:
        return allIn(_that);
      case _GameControlCallResult() when call != null:
        return call(_that);
      case _GameControlCheckResult() when check != null:
        return check(_that);
      case _GameControlFoldResult() when fold != null:
        return fold(_that);
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
    TResult Function(int raiseValue)? raise,
    TResult Function()? allIn,
    TResult Function()? call,
    TResult Function()? check,
    TResult Function()? fold,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult() when raise != null:
        return raise(_that.raiseValue);
      case _GameControlAllInResult() when allIn != null:
        return allIn();
      case _GameControlCallResult() when call != null:
        return call();
      case _GameControlCheckResult() when check != null:
        return check();
      case _GameControlFoldResult() when fold != null:
        return fold();
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
    required TResult Function(int raiseValue) raise,
    required TResult Function() allIn,
    required TResult Function() call,
    required TResult Function() check,
    required TResult Function() fold,
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult():
        return raise(_that.raiseValue);
      case _GameControlAllInResult():
        return allIn();
      case _GameControlCallResult():
        return call();
      case _GameControlCheckResult():
        return check();
      case _GameControlFoldResult():
        return fold();
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
    TResult? Function(int raiseValue)? raise,
    TResult? Function()? allIn,
    TResult? Function()? call,
    TResult? Function()? check,
    TResult? Function()? fold,
  }) {
    final _that = this;
    switch (_that) {
      case GameControlRaiseResult() when raise != null:
        return raise(_that.raiseValue);
      case _GameControlAllInResult() when allIn != null:
        return allIn();
      case _GameControlCallResult() when call != null:
        return call();
      case _GameControlCheckResult() when check != null:
        return check();
      case _GameControlFoldResult() when fold != null:
        return fold();
      case _:
        return null;
    }
  }
}

/// @nodoc

class GameControlRaiseResult implements GameControlResult {
  const GameControlRaiseResult({required this.raiseValue});

  final int raiseValue;

  /// Create a copy of GameControlResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameControlRaiseResultCopyWith<GameControlRaiseResult> get copyWith =>
      _$GameControlRaiseResultCopyWithImpl<GameControlRaiseResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameControlRaiseResult &&
            (identical(other.raiseValue, raiseValue) ||
                other.raiseValue == raiseValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, raiseValue);

  @override
  String toString() {
    return 'GameControlResult.raise(raiseValue: $raiseValue)';
  }
}

/// @nodoc
abstract mixin class $GameControlRaiseResultCopyWith<$Res>
    implements $GameControlResultCopyWith<$Res> {
  factory $GameControlRaiseResultCopyWith(GameControlRaiseResult value,
          $Res Function(GameControlRaiseResult) _then) =
      _$GameControlRaiseResultCopyWithImpl;
  @useResult
  $Res call({int raiseValue});
}

/// @nodoc
class _$GameControlRaiseResultCopyWithImpl<$Res>
    implements $GameControlRaiseResultCopyWith<$Res> {
  _$GameControlRaiseResultCopyWithImpl(this._self, this._then);

  final GameControlRaiseResult _self;
  final $Res Function(GameControlRaiseResult) _then;

  /// Create a copy of GameControlResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? raiseValue = null,
  }) {
    return _then(GameControlRaiseResult(
      raiseValue: null == raiseValue
          ? _self.raiseValue
          : raiseValue // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _GameControlAllInResult implements GameControlResult {
  const _GameControlAllInResult();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GameControlAllInResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GameControlResult.allIn()';
  }
}

/// @nodoc

class _GameControlCallResult implements GameControlResult {
  const _GameControlCallResult();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GameControlCallResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GameControlResult.call()';
  }
}

/// @nodoc

class _GameControlCheckResult implements GameControlResult {
  const _GameControlCheckResult();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GameControlCheckResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GameControlResult.check()';
  }
}

/// @nodoc

class _GameControlFoldResult implements GameControlResult {
  const _GameControlFoldResult();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _GameControlFoldResult);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'GameControlResult.fold()';
  }
}

// dart format on
