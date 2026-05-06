import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/feature/main_shell/presentation/state/menu_item.dart';

/// Provider quản lý index hiện tại của Bottom Navigation Bar
final bottomNavProvider = NotifierProvider<MainShellProvider, int>(() {
  return MainShellProvider();
});

class MainShellProvider extends Notifier<int> {
  @override
  int build() => 0;

  final List<MenuItem> menuItems = const [
    MenuItem(
      index: 0,
      path: AppRoutes.home,
      icon: Icons.dashboard_rounded,
      label: 'Home',
    ),
    MenuItem(
      index: 1,
      path: AppRoutes.playList,
      icon: Icons.library_music_rounded,
      label: 'Library',
    ),
    MenuItem(
      index: 2,
      path: AppRoutes.setting,
      icon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  /// Cập nhật index mới
  void setIndex(int index) {
    state = index;
  }

  void syncWithLocation(String location) {
    for (int i = 0; i < appRoutes.length; i++) {
      if (location.startsWith(appRoutes[i])) {
        state = i;
        return;
      }
    }
  }

  /// route cho bottom menu
  final List<String> appRoutes = [AppRoutes.home, AppRoutes.playList, AppRoutes.setting];

}