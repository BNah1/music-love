part of 'library_bloc.dart';

@freezed
abstract class LibraryEvent with _$LibraryEvent {
  const factory LibraryEvent.printLibrary() = _PrintLibrary;
}
