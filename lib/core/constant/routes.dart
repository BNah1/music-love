import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';





class AppRoutes {

  ///Route name
  static const String home = '/home';
  static const String taskView = '/taskView';
  static const String onBoarding = '/onBoarding';
  static const String chatBox = '/chatBox';
  static const String userInfoChat = '/userInfoChat';
  static const String searchChat = '/searchChat';
  static const String test = '/test';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {


      default:
        return _cupertinoRoute(Scaffold(
          body: Center(
            child: Text(
              'Wrong Route provided ${settings.name}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ));
    }
  }

  static Route _cupertinoRoute(Widget view) => CupertinoPageRoute(
    builder: (_) => view,
  );

  AppRoutes._();
}