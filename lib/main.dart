import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/home_view.dart';

import 'feature/presentation/view/chat_view.dart';
import 'feature/play_music/presentation/view/widget/play_music_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      // const PlayMusicView(),
      const ChatView(),
    );
  }
}
