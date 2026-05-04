import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/feature/main_shell_view.dart';
import 'package:musiclove/feature/playlist/presentation/view/playlist_detail_view.dart';
import 'package:musiclove/feature/playlist/presentation/view/playlist_view.dart';
import 'package:musiclove/feature/setting/presentation/view/setting_headphone_bluetooth_view.dart';
import 'package:musiclove/feature/setting/presentation/view/setting_library_view.dart';
import 'package:musiclove/feature/setting/presentation/view/setting_player_music_view.dart';
import 'package:musiclove/feature/setting/presentation/view/setting_theme_view.dart';
import 'package:musiclove/feature/setting/presentation/view/setting_view.dart';
import 'package:musiclove/home_view.dart';
import 'package:musiclove/feature/play_music/presentation/view/play_music_view.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRoutes {

  ///////////////////////////////
  ////   Route names
  ///////////////////////////////

  static const String home = '/home';
  static const String playList = '/playList';
  static const String playMusic = '/playMusic';
  static const String setting = '/setting';
  static const String settingTheme = '/settingTheme';
  static const String settingBluetooth = '/settingBluetooth';
  static const String settingLibrary = '/settingLibrary';
  static const String settingMusicPlayer = '/settingMusicPlayer';

  // Khởi tạo GoRouter
  static final GoRouter router = GoRouter(
    initialLocation: home,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    errorBuilder: (context, state) => _errorRoute(state),
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShellView(child: child);
        },
        routes: [
          GoRoute(
            path: home, // Dashboard
            pageBuilder: (context, state) => const CupertinoPage(child: HomeView()),
          ),
          GoRoute(
            path: playList,
            pageBuilder: (context, state) => const CupertinoPage(child: PlaylistView()),
          ),
          GoRoute(
            path: setting,
            pageBuilder: (context, state) => const CupertinoPage(child: SettingView()),
          ),

        ],
      ),


      GoRoute(
        path: settingMusicPlayer,
        pageBuilder: (context, state) => const CupertinoPage(child: SettingPlayerMusicView()),
      ),

      GoRoute(
        path: settingTheme,
        pageBuilder: (context, state) => const CupertinoPage(child: SettingThemeView()),
      ),

      GoRoute(
        path: settingBluetooth,
        pageBuilder: (context, state) => const CupertinoPage(child: SettingHeadphoneBluetoothView()),
      ),

      GoRoute(
        path: settingLibrary,
        pageBuilder: (context, state) => const CupertinoPage(child: SettingLibraryView()),
      ),

      GoRoute(
        path: '$playList/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CupertinoPage(
            child: PlaylistDetailView(playlistId: id),
          );
        },
      ),

      GoRoute(
        path: '${AppRoutes.playMusic}/:songId',
        pageBuilder: (context, state) {
          final songId = state.pathParameters['songId']!;
          final playlistId = state.uri.queryParameters['playlistId'];

          return CupertinoPage(
            child: PlayMusicView(
              songId: songId,
              playlistId: playlistId,
            ),
          );
        },
      ),

    ],
  );

  static String playlistDetail(String id) => '$playList/$id';

  // Widget hiển thị khi sai Route
  static Widget _errorRoute(GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text(
          'Wrong Route provided ${state.uri}',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  AppRoutes._();
}