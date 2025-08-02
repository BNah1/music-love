// listen_now_state.dart
// Tương tự, file này phải là một phần của listen_now_bloc.dart
part of 'listen_now_bloc.dart';

// Và cần khai báo part cho các file được tạo tự động
// Ví dụ: `part 'generated/listen_now_state.freezed.dart';`
// hoặc `part 'listen_now_state.freezed.dart';` nếu chúng ở cùng thư mục.
@freezed
abstract class ListenNowState with _$ListenNowState {
  const factory ListenNowState([@Default("") String helloWorld]) =
      _ListenNowState;
}
