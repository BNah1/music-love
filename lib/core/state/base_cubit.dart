import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  final GlobalCubit globalCubit;

  BaseCubit(this.globalCubit, T initialState) : super(initialState);

  void showGlobalLoading() => globalCubit.showLoading();
  void hideGlobalLoading() => globalCubit.hideLoading();
}

class GlobalCubit extends Cubit<bool> {
  GlobalCubit() : super(false);

  void showLoading() => emit(true);
  void hideLoading() => emit(false);
}
