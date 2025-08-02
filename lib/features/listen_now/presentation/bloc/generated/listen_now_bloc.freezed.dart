// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../listen_now_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListenNowEvent {
  String get text;

  /// Create a copy of ListenNowEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListenNowEventCopyWith<ListenNowEvent> get copyWith =>
      _$ListenNowEventCopyWithImpl<ListenNowEvent>(
          this as ListenNowEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListenNowEvent &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'ListenNowEvent(text: $text)';
  }
}

/// @nodoc
abstract mixin class $ListenNowEventCopyWith<$Res> {
  factory $ListenNowEventCopyWith(
          ListenNowEvent value, $Res Function(ListenNowEvent) _then) =
      _$ListenNowEventCopyWithImpl;
  @useResult
  $Res call({String text});
}

/// @nodoc
class _$ListenNowEventCopyWithImpl<$Res>
    implements $ListenNowEventCopyWith<$Res> {
  _$ListenNowEventCopyWithImpl(this._self, this._then);

  final ListenNowEvent _self;
  final $Res Function(ListenNowEvent) _then;

  /// Create a copy of ListenNowEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_self.copyWith(
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ListenNowEvent].
extension ListenNowEventPatterns on ListenNowEvent {
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
    TResult Function(_PrintHelloWorld value)? printHelloWorld,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld() when printHelloWorld != null:
        return printHelloWorld(_that);
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
    required TResult Function(_PrintHelloWorld value) printHelloWorld,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld():
        return printHelloWorld(_that);
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
    TResult? Function(_PrintHelloWorld value)? printHelloWorld,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld() when printHelloWorld != null:
        return printHelloWorld(_that);
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
    TResult Function(String text)? printHelloWorld,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld() when printHelloWorld != null:
        return printHelloWorld(_that.text);
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
    required TResult Function(String text) printHelloWorld,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld():
        return printHelloWorld(_that.text);
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
    TResult? Function(String text)? printHelloWorld,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintHelloWorld() when printHelloWorld != null:
        return printHelloWorld(_that.text);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PrintHelloWorld implements ListenNowEvent {
  const _PrintHelloWorld(this.text);

  @override
  final String text;

  /// Create a copy of ListenNowEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PrintHelloWorldCopyWith<_PrintHelloWorld> get copyWith =>
      __$PrintHelloWorldCopyWithImpl<_PrintHelloWorld>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PrintHelloWorld &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @override
  String toString() {
    return 'ListenNowEvent.printHelloWorld(text: $text)';
  }
}

/// @nodoc
abstract mixin class _$PrintHelloWorldCopyWith<$Res>
    implements $ListenNowEventCopyWith<$Res> {
  factory _$PrintHelloWorldCopyWith(
          _PrintHelloWorld value, $Res Function(_PrintHelloWorld) _then) =
      __$PrintHelloWorldCopyWithImpl;
  @override
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$PrintHelloWorldCopyWithImpl<$Res>
    implements _$PrintHelloWorldCopyWith<$Res> {
  __$PrintHelloWorldCopyWithImpl(this._self, this._then);

  final _PrintHelloWorld _self;
  final $Res Function(_PrintHelloWorld) _then;

  /// Create a copy of ListenNowEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? text = null,
  }) {
    return _then(_PrintHelloWorld(
      null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ListenNowState {
  String get helloWorld;

  /// Create a copy of ListenNowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListenNowStateCopyWith<ListenNowState> get copyWith =>
      _$ListenNowStateCopyWithImpl<ListenNowState>(
          this as ListenNowState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListenNowState &&
            (identical(other.helloWorld, helloWorld) ||
                other.helloWorld == helloWorld));
  }

  @override
  int get hashCode => Object.hash(runtimeType, helloWorld);

  @override
  String toString() {
    return 'ListenNowState(helloWorld: $helloWorld)';
  }
}

/// @nodoc
abstract mixin class $ListenNowStateCopyWith<$Res> {
  factory $ListenNowStateCopyWith(
          ListenNowState value, $Res Function(ListenNowState) _then) =
      _$ListenNowStateCopyWithImpl;
  @useResult
  $Res call({String helloWorld});
}

/// @nodoc
class _$ListenNowStateCopyWithImpl<$Res>
    implements $ListenNowStateCopyWith<$Res> {
  _$ListenNowStateCopyWithImpl(this._self, this._then);

  final ListenNowState _self;
  final $Res Function(ListenNowState) _then;

  /// Create a copy of ListenNowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? helloWorld = null,
  }) {
    return _then(_self.copyWith(
      helloWorld: null == helloWorld
          ? _self.helloWorld
          : helloWorld // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ListenNowState].
extension ListenNowStatePatterns on ListenNowState {
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
    TResult Function(_ListenNowState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ListenNowState() when $default != null:
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
    TResult Function(_ListenNowState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ListenNowState():
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
    TResult? Function(_ListenNowState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ListenNowState() when $default != null:
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
    TResult Function(String helloWorld)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ListenNowState() when $default != null:
        return $default(_that.helloWorld);
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
    TResult Function(String helloWorld) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ListenNowState():
        return $default(_that.helloWorld);
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
    TResult? Function(String helloWorld)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ListenNowState() when $default != null:
        return $default(_that.helloWorld);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ListenNowState implements ListenNowState {
  const _ListenNowState([this.helloWorld = ""]);

  @override
  @JsonKey()
  final String helloWorld;

  /// Create a copy of ListenNowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ListenNowStateCopyWith<_ListenNowState> get copyWith =>
      __$ListenNowStateCopyWithImpl<_ListenNowState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ListenNowState &&
            (identical(other.helloWorld, helloWorld) ||
                other.helloWorld == helloWorld));
  }

  @override
  int get hashCode => Object.hash(runtimeType, helloWorld);

  @override
  String toString() {
    return 'ListenNowState(helloWorld: $helloWorld)';
  }
}

/// @nodoc
abstract mixin class _$ListenNowStateCopyWith<$Res>
    implements $ListenNowStateCopyWith<$Res> {
  factory _$ListenNowStateCopyWith(
          _ListenNowState value, $Res Function(_ListenNowState) _then) =
      __$ListenNowStateCopyWithImpl;
  @override
  @useResult
  $Res call({String helloWorld});
}

/// @nodoc
class __$ListenNowStateCopyWithImpl<$Res>
    implements _$ListenNowStateCopyWith<$Res> {
  __$ListenNowStateCopyWithImpl(this._self, this._then);

  final _ListenNowState _self;
  final $Res Function(_ListenNowState) _then;

  /// Create a copy of ListenNowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? helloWorld = null,
  }) {
    return _then(_ListenNowState(
      null == helloWorld
          ? _self.helloWorld
          : helloWorld // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
