import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/feature/main_shell/presentation/view/widget/bottom_nav_widget.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/mini_player_overlay.dart';

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
            child: Padding(
              padding: EdgeInsets.only(bottom: 75),
              child: MiniPlayerOverlay(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: BottomNavWidget(),
      ),
    );
  }
}
