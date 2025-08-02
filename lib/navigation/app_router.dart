// import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/features/home_navigation/home_navigation.dart';
import 'package:musiclove/features/library/presentation/bloc/library_bloc.dart';
import 'package:musiclove/features/library/presentation/pages/library_page.dart';
import 'package:musiclove/features/listen_now/presentation/bloc/listen_now_bloc.dart';
import 'package:musiclove/features/listen_now/presentation/pages/listen_now_page.dart';

part 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigationKey =
      GlobalKey<NavigatorState>(debugLabel: "root");

  // static Amplitude amplitude = DI()

  static final router = GoRouter(
    initialLocation: RoutePaths.listenNow,
    navigatorKey: rootNavigationKey,
    routes: [
      // StatefulShellBranch(routes: []),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ListenNowBloc()),
              BlocProvider(create: (context) => LibraryBloc()),
            ],
            child: HomeNavigation(child: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.listenNow,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: ListenNowPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.library,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: LibraryPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
