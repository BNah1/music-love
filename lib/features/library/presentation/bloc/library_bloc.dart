import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_event.dart';
part 'library_state.dart';

part 'generated/library_bloc.freezed.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(const LibraryState()) {
    on<LibraryEvent>((event, emit) {
      event.map(printLibrary: (event) => _onPrintLibrary(event, emit));
    });
  }

  _onPrintLibrary(_PrintLibrary event, Emitter<LibraryState> emit) {
    debugPrint("LibraryBloc: printLibrary");
    if (state.librartString == "") {
      emit(state.copyWith(librartString: "Library"));
    } else {
      emit(state.copyWith(librartString: "Hi"));
    }
    debugPrint("LibraryBloc: printLibrary - success");
  }
}
