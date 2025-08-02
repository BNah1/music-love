import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/navigation/app_router.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell child;

  const HomeNavigation({Key? key, required this.child}) : super(key: key);

  static const routes = [RoutePaths.listenNow];

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.child.currentIndex,
        onTap: (index) {
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: "Listen Now",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: "Library",
          ),
        ],
      ),
    );
  }
}
