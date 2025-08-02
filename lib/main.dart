import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musiclove/app.dart';
import 'package:musiclove/configs/di.dart';
import 'package:musiclove/core/utils/global_values.dart';
// import 'package:musiclove/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await Future.wait([DI().init(), GlobalValues.init()]);

  runApp(const App());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const HomeView(),
//     );
//   }
// }
