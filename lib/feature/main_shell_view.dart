import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/mini_player_overlay.dart';

import '../core/constant/routes.dart';

class MainShellView extends StatelessWidget {
  const MainShellView({super.key, required this.child});
   final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          child,
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayerOverlay(),
          ),

          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _buildBottomNav(context))

        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith(AppRoutes.playList)) currentIndex = 1;
    if (location.startsWith(AppRoutes.setting)) currentIndex = 2;


    return SafeArea(
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8), // Nền nhạt hơn cho thanh bar
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Lớp nền chạy (Indicator)
            _buildAnimatedIndicator(currentIndex),

            // Các Icon chính
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.dashboard_rounded, "Home", currentIndex),
                _buildNavItem(context, 1, Icons.library_music_rounded, "Library", currentIndex),
                _buildNavItem(context, 2, Icons.settings_rounded, "Settings", currentIndex),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Widget điều khiển "viên thuốc" chạy dưới icon
  Widget _buildAnimatedIndicator(int currentIndex) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCirc,
      alignment: Alignment(
        -1.0 + (currentIndex * 1.0),
        0,
      ),
      child: FractionallySizedBox(
        widthFactor: 1 / 3, // Chia thanh bar làm 3 phần
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8EC5FC).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Item từng nút bấm
  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, int currentIndex) {
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
                color: isSelected ? Colors.white : Colors.blueGrey.withOpacity(0.5),
                size: 26,
              ),
            ),
            if (isSelected)
              const Text(
                "", // Bạn có thể thêm label cực nhỏ ở đây nếu muốn
                style: TextStyle(fontSize: 0),
              ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go(AppRoutes.home); break;
      case 1: context.go(AppRoutes.playList); break;
      case 2: context.go(AppRoutes.setting); break;
    }
  }

}