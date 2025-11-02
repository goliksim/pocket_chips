// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSettingsModel {
  int? get startingStack;
  int? get smallBlind;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameSettingsModelCopyWith<GameSettingsModel> get copyWith =>
      _$GameSettingsModelCopyWithImpl<GameSettingsModel>(
          this as GameSettingsModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameSettingsModel &&
            (identical(other.startingStack, startingStack) ||
                other.startingStack == startingStack) &&
            (identical(other.smallBlind, smallBlind) ||
                other.smallBlind == smallBlind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startingStack, smallBlind);

  @override
  String toString() {
    return 'GameSettingsModel(startingStack: $startingStack, smallBlind: $smallBlind)';
  }
}

/// @nodoc
abstract mixin class $GameSettingsModelCopyWith<$Res> {
  factory $GameSettingsModelCopyWith(
          GameSettingsModel value, $Res Function(GameSettingsModel) _then) =
      _$GameSettingsModelCopyWithImpl;
  @useResult
  $Res call({int startingStack, int smallBlind});
}

/// @nodoc
class _$GameSettingsModelCopyWithImpl<$Res>
    implements $GameSettingsModelCopyWith<$Res> {
  _$GameSettingsModelCopyWithImpl(this._self, this._then);

  final GameSettingsModel _self;
  final $Res Function(GameSettingsModel) _then;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startingStack = null,
    Object? smallBlind = null,
  }) {
    return _then(_self.copyWith(
      startingStack: null == startingStack
          ? _self.startingStack!
          : startingStack // ignore: cast_nullable_to_non_nullable
              as int,
      smallBlind: null == smallBlind
          ? _self.smallBlind!
          : smallBlind // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [GameSettingsModel].
extension GameSettingsModelPatterns on GameSettingsModel {
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
    TResult Function(GameSettingsModelArgs value)? $default, {
    TResult Function(GameSettingsModelResult value)? result,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs() when $default != null:
        return $default(_that);
      case GameSettingsModelResult() when result != null:
        return result(_that);
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
    TResult Function(GameSettingsModelArgs value) $default, {
    required TResult Function(GameSettingsModelResult value) result,
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs():
        return $default(_that);
      case GameSettingsModelResult():
        return result(_that);
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
    TResult? Function(GameSettingsModelArgs value)? $default, {
    TResult? Function(GameSettingsModelResult value)? result,
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs() when $default != null:
        return $default(_that);
      case GameSettingsModelResult() when result != null:
        return result(_that);
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
    TResult Function(int startingStack, bool canEditStack, int smallBlind)?
        $default, {
    TResult Function(int? startingStack, int? smallBlind)? result,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs() when $default != null:
        return $default(
            _that.startingStack, _that.canEditStack, _that.smallBlind);
      case GameSettingsModelResult() when result != null:
        return result(_that.startingStack, _that.smallBlind);
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
    TResult Function(int startingStack, bool canEditStack, int smallBlind)
        $default, {
    required TResult Function(int? startingStack, int? smallBlind) result,
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs():
        return $default(
            _that.startingStack, _that.canEditStack, _that.smallBlind);
      case GameSettingsModelResult():
        return result(_that.startingStack, _that.smallBlind);
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
    TResult? Function(int startingStack, bool canEditStack, int smallBlind)?
        $default, {
    TResult? Function(int? startingStack, int? smallBlind)? result,
  }) {
    final _that = this;
    switch (_that) {
      case GameSettingsModelArgs() when $default != null:
        return $default(
            _that.startingStack, _that.canEditStack, _that.smallBlind);
      case GameSettingsModelResult() when result != null:
        return result(_that.startingStack, _that.smallBlind);
      case _:
        return null;
    }
  }
}

/// @nodoc

class GameSettingsModelArgs implements GameSettingsModel {
  const GameSettingsModelArgs(
      {required this.startingStack,
      required this.canEditStack,
      required this.smallBlind});

  @override
  final int startingStack;
  final bool canEditStack;
  @override
  final int smallBlind;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameSettingsModelArgsCopyWith<GameSettingsModelArgs> get copyWith =>
      _$GameSettingsModelArgsCopyWithImpl<GameSettingsModelArgs>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameSettingsModelArgs &&
            (identical(other.startingStack, startingStack) ||
                other.startingStack == startingStack) &&
            (identical(other.canEditStack, canEditStack) ||
                other.canEditStack == canEditStack) &&
            (identical(other.smallBlind, smallBlind) ||
                other.smallBlind == smallBlind));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, startingStack, canEditStack, smallBlind);

  @override
  String toString() {
    return 'GameSettingsModel(startingStack: $startingStack, canEditStack: $canEditStack, smallBlind: $smallBlind)';
  }
}

/// @nodoc
abstract mixin class $GameSettingsModelArgsCopyWith<$Res>
    implements $GameSettingsModelCopyWith<$Res> {
  factory $GameSettingsModelArgsCopyWith(GameSettingsModelArgs value,
          $Res Function(GameSettingsModelArgs) _then) =
      _$GameSettingsModelArgsCopyWithImpl;
  @override
  @useResult
  $Res call({int startingStack, bool canEditStack, int smallBlind});
}

/// @nodoc
class _$GameSettingsModelArgsCopyWithImpl<$Res>
    implements $GameSettingsModelArgsCopyWith<$Res> {
  _$GameSettingsModelArgsCopyWithImpl(this._self, this._then);

  final GameSettingsModelArgs _self;
  final $Res Function(GameSettingsModelArgs) _then;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startingStack = null,
    Object? canEditStack = null,
    Object? smallBlind = null,
  }) {
    return _then(GameSettingsModelArgs(
      startingStack: null == startingStack
          ? _self.startingStack
          : startingStack // ignore: cast_nullable_to_non_nullable
              as int,
      canEditStack: null == canEditStack
          ? _self.canEditStack
          : canEditStack // ignore: cast_nullable_to_non_nullable
              as bool,
      smallBlind: null == smallBlind
          ? _self.smallBlind
          : smallBlind // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class GameSettingsModelResult implements GameSettingsModel {
  const GameSettingsModelResult(
      {required this.startingStack, required this.smallBlind});

  @override
  final int? startingStack;
  @override
  final int? smallBlind;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GameSettingsModelResultCopyWith<GameSettingsModelResult> get copyWith =>
      _$GameSettingsModelResultCopyWithImpl<GameSettingsModelResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GameSettingsModelResult &&
            (identical(other.startingStack, startingStack) ||
                other.startingStack == startingStack) &&
            (identical(other.smallBlind, smallBlind) ||
                other.smallBlind == smallBlind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startingStack, smallBlind);

  @override
  String toString() {
    return 'GameSettingsModel.result(startingStack: $startingStack, smallBlind: $smallBlind)';
  }
}

/// @nodoc
abstract mixin class $GameSettingsModelResultCopyWith<$Res>
    implements $GameSettingsModelCopyWith<$Res> {
  factory $GameSettingsModelResultCopyWith(GameSettingsModelResult value,
          $Res Function(GameSettingsModelResult) _then) =
      _$GameSettingsModelResultCopyWithImpl;
  @override
  @useResult
  $Res call({int? startingStack, int? smallBlind});
}

/// @nodoc
class _$GameSettingsModelResultCopyWithImpl<$Res>
    implements $GameSettingsModelResultCopyWith<$Res> {
  _$GameSettingsModelResultCopyWithImpl(this._self, this._then);

  final GameSettingsModelResult _self;
  final $Res Function(GameSettingsModelResult) _then;

  /// Create a copy of GameSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startingStack = freezed,
    Object? smallBlind = freezed,
  }) {
    return _then(GameSettingsModelResult(
      startingStack: freezed == startingStack
          ? _self.startingStack
          : startingStack // ignore: cast_nullable_to_non_nullable
              as int?,
      smallBlind: freezed == smallBlind
          ? _self.smallBlind
          : smallBlind // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
