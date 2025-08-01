import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/model/base_state.dart';

Future<String?> handleCubitCall({
  required BaseState state,
  required Emitter emit,
  required Future<void> Function() action,
}) async {
  try {
    emit(state.copyWith(status: BaseStatus.loading));
    await action();
    emit(state.copyWith(status: BaseStatus.loaded));
    return null;
  } catch (e) {
    emit(state.copyWith(status: BaseStatus.error, errorMessage: e.toString()));
    return e.toString();
  }
}
