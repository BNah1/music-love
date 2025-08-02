part of 'library_bloc.dart';

@freezed
abstract class LibraryState with _$LibraryState {
  const factory LibraryState({@Default("") String librartString}) =
      _LibraryState;
}
