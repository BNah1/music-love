part of 'listen_now_bloc.dart';

@freezed
abstract class ListenNowEvent with _$ListenNowEvent {
  const factory ListenNowEvent.printHelloWorld(String text) = _PrintHelloWorld;
}
