import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'listen_now_event.dart';
part 'listen_now_state.dart';

part 'generated/listen_now_bloc.freezed.dart';

class ListenNowBloc extends Bloc<ListenNowEvent, ListenNowState> {
  ListenNowBloc() : super(const ListenNowState()) {
    on<ListenNowEvent>((event, emit) {
      event.map(printHelloWorld: (event) => _onPrintHelloWorld(event, emit));
    });
  }

  _onPrintHelloWorld(_PrintHelloWorld event, Emitter<ListenNowState> emit) {
    debugPrint("ListtenNowBloc: printHelloWorld");
    // if (state.helloWorld == "") {
    //   emit(state.copyWith(helloWorld: "Hello World"));
    // } else {
    //   emit(state.copyWith(helloWorld: "Hi"));
    // }
    emit(state.copyWith(helloWorld: event.text));
    debugPrint("ListtenNowBloc: printHelloWorld - success");
  }
}
