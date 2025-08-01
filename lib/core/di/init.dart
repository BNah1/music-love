
class AppInit {
  static Future<void> init() async {

  }

  // static Future<void> registerDI() async {
  //   getIt.registerLazySingleton<ChatService>(() => ChatService());
  //   getIt.registerLazySingleton<ChatRepository>(
  //     () => ChatRepository(getIt<ChatService>()),
  //   );
  //
  //   getIt.registerLazySingleton<ProjectService>(() => ProjectService());
  //   getIt.registerLazySingleton<ProjectRepository>(
  //     () => ProjectRepository(getIt<ProjectService>()),
  //   );
  //
  //   getIt.registerLazySingleton<AuthService>(() => AuthService());
  //   getIt.registerLazySingleton<AuthRepository>(
  //     () => AuthRepository(getIt<AuthService>()),
  //   );
  //
  //   getIt.registerLazySingleton<TaskService>(() => TaskService());
  //   getIt.registerLazySingleton<TaskRepository>(
  //     () => TaskRepository(getIt<TaskService>()),
  //   );
  // }
  //
  // static Future<void> createCubit() async {
  //   chatCubit = ChatCubit();
  //   projectCubit = ProjectCubit();
  //   taskCubit = TaskCubit(repository: getIt<TaskRepository>());
  // }
  //
  // static Future<void> registerUseCase() async {
  //   getIt.registerLazySingleton<ProjectTaskUseCase>(
  //     () => ProjectTaskUseCase(taskCubit, projectCubit),
  //   );
  // }
}
