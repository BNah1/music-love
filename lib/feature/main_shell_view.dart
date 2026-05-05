import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/mini_player_overlay.dart';

import '../core/constant/routes.dart';
import '../core/constant/theme.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          navigationShell,
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayerOverlay(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith(AppRoutes.playList)) currentIndex = 1;
    if (location.startsWith(AppRoutes.setting)) currentIndex = 2;

    return SafeArea(
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: appTheme.navBackground,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildAnimatedIndicator(context, currentIndex),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  0,
                  Icons.dashboard_rounded,
                  'Home',
                  currentIndex,
                ),
                _buildNavItem(
                  context,
                  1,
                  Icons.library_music_rounded,
                  'Library',
                  currentIndex,
                ),
                _buildNavItem(
                  context,
                  2,
                  Icons.settings_rounded,
                  'Settings',
                  currentIndex,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIndicator(BuildContext context, int currentIndex) {
    final appTheme = AppTheme.extensionOf(context);

    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCirc,
      alignment: Alignment(
        -1.0 + (currentIndex * 1.0),
        0,
      ),
      child: FractionallySizedBox(
        widthFactor: 1 / 3,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: appTheme.navIndicatorGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: appTheme.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    int currentIndex,
  ) {
    final appTheme = AppTheme.extensionOf(context);
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index, context),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                icon,
                color: isSelected
                    ? appTheme.selectedIconColor
                    : appTheme.unselectedIconColor,
                size: 26,
              ),
            ),
            if (isSelected)
              const Text(
                '',
                style: TextStyle(fontSize: 0),
              ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.playList);
        break;
      case 2:
        context.go(AppRoutes.setting);
        break;
    }
  }
}
