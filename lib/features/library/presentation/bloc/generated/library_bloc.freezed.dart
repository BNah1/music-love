// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../library_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryEvent implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'LibraryEvent'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LibraryEvent()';
  }
}

/// @nodoc
class $LibraryEventCopyWith<$Res> {
  $LibraryEventCopyWith(LibraryEvent _, $Res Function(LibraryEvent) __);
}

/// Adds pattern-matching-related methods to [LibraryEvent].
extension LibraryEventPatterns on LibraryEvent {
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
    TResult Function(_PrintLibrary value)? printLibrary,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary() when printLibrary != null:
        return printLibrary(_that);
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
    required TResult Function(_PrintLibrary value) printLibrary,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary():
        return printLibrary(_that);
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
    TResult? Function(_PrintLibrary value)? printLibrary,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary() when printLibrary != null:
        return printLibrary(_that);
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
    TResult Function()? printLibrary,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary() when printLibrary != null:
        return printLibrary();
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
    required TResult Function() printLibrary,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary():
        return printLibrary();
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
    TResult? Function()? printLibrary,
  }) {
    final _that = this;
    switch (_that) {
      case _PrintLibrary() when printLibrary != null:
        return printLibrary();
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PrintLibrary with DiagnosticableTreeMixin implements LibraryEvent {
  const _PrintLibrary();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'LibraryEvent.printLibrary'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _PrintLibrary);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LibraryEvent.printLibrary()';
  }
}

/// @nodoc
mixin _$LibraryState implements DiagnosticableTreeMixin {
  String get librartString;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryStateCopyWith<LibraryState> get copyWith =>
      _$LibraryStateCopyWithImpl<LibraryState>(
          this as LibraryState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LibraryState'))
      ..add(DiagnosticsProperty('librartString', librartString));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryState &&
            (identical(other.librartString, librartString) ||
                other.librartString == librartString));
  }

  @override
  int get hashCode => Object.hash(runtimeType, librartString);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LibraryState(librartString: $librartString)';
  }
}

/// @nodoc
abstract mixin class $LibraryStateCopyWith<$Res> {
  factory $LibraryStateCopyWith(
          LibraryState value, $Res Function(LibraryState) _then) =
      _$LibraryStateCopyWithImpl;
  @useResult
  $Res call({String librartString});
}

/// @nodoc
class _$LibraryStateCopyWithImpl<$Res> implements $LibraryStateCopyWith<$Res> {
  _$LibraryStateCopyWithImpl(this._self, this._then);

  final LibraryState _self;
  final $Res Function(LibraryState) _then;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? librartString = null,
  }) {
    return _then(_self.copyWith(
      librartString: null == librartString
          ? _self.librartString
          : librartString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [LibraryState].
extension LibraryStatePatterns on LibraryState {
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
    TResult Function(_LibraryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryState() when $default != null:
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
    TResult Function(_LibraryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryState():
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
    TResult? Function(_LibraryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryState() when $default != null:
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
    TResult Function(String librartString)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryState() when $default != null:
        return $default(_that.librartString);
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
    TResult Function(String librartString) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryState():
        return $default(_that.librartString);
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
    TResult? Function(String librartString)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryState() when $default != null:
        return $default(_that.librartString);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LibraryState with DiagnosticableTreeMixin implements LibraryState {
  const _LibraryState({this.librartString = ""});

  @override
  @JsonKey()
  final String librartString;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LibraryStateCopyWith<_LibraryState> get copyWith =>
      __$LibraryStateCopyWithImpl<_LibraryState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'LibraryState'))
      ..add(DiagnosticsProperty('librartString', librartString));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LibraryState &&
            (identical(other.librartString, librartString) ||
                other.librartString == librartString));
  }

  @override
  int get hashCode => Object.hash(runtimeType, librartString);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LibraryState(librartString: $librartString)';
  }
}

/// @nodoc
abstract mixin class _$LibraryStateCopyWith<$Res>
    implements $LibraryStateCopyWith<$Res> {
  factory _$LibraryStateCopyWith(
          _LibraryState value, $Res Function(_LibraryState) _then) =
      __$LibraryStateCopyWithImpl;
  @override
  @useResult
  $Res call({String librartString});
}

/// @nodoc
class __$LibraryStateCopyWithImpl<$Res>
    implements _$LibraryStateCopyWith<$Res> {
  __$LibraryStateCopyWithImpl(this._self, this._then);

  final _LibraryState _self;
  final $Res Function(_LibraryState) _then;

  /// Create a copy of LibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? librartString = null,
  }) {
    return _then(_LibraryState(
      librartString: null == librartString
          ? _self.librartString
          : librartString // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
