import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constant/routes.dart';
import 'core/constant/theme.dart';
import 'feature/setting/domain/repository/setting_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Box settingsBox = Hive.box('settings');

    return ValueListenableBuilder<Box>(
      valueListenable: settingsBox.listenable(
        keys: const [
          SettingKeys.themeMode,
          SettingKeys.themeStyle,
        ],
      ),
      builder: (context, box, _) {
        final String themeModeValue = box.get(
          SettingKeys.themeMode,
          defaultValue: 'system',
        ) as String;

        final String themeStyleValue = box.get(
          SettingKeys.themeStyle,
          defaultValue: AppThemePreset.musicLove.value,
        ) as String;

        final AppThemePreset preset = AppTheme.presetFromString(themeStyleValue);

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoutes.router,
          title: 'Music App',
          themeMode: AppTheme.themeModeFromString(themeModeValue),
          theme: AppTheme.themeData(
            preset: preset,
            brightness: Brightness.light,
          ),
          darkTheme: AppTheme.themeData(
            preset: preset,
            brightness: Brightness.dark,
          ),
        );
      },
    );
  }
}
