import 'package:get_it/get_it.dart';
import 'package:musiclove/features/library/presentation/bloc/library_bloc.dart';
import 'package:musiclove/features/listen_now/presentation/bloc/listen_now_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DI {
  static DI? _instance;
  DI._();

  factory DI() {
    _instance ??= DI._();
    return _instance!;
  }

  final sl = GetIt.instance;

  Future<void> init() async {
    sl.registerLazySingleton<ListenNowBloc>(() => ListenNowBloc());
    sl.registerLazySingleton<LibraryBloc>(() => LibraryBloc());

    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
  }
}
