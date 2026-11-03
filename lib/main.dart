import 'package:audio_service/audio_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/audio/music_audio_handler.dart';
import 'core/constant/app_assets.dart';
import 'core/constant/app_config.dart';
import 'core/provider/audio_handler_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Khởi tạo local database với hằng số AppConfig.
  await Hive.initFlutter();

  await Hive.openBox(AppConfig.boxSongs);
  await Hive.openBox(AppConfig.boxPlaylists);
  await Hive.openBox(AppConfig.boxPlayerCache);
  await Hive.openBox(AppConfig.boxSettings);

  // Khởi tạo audio service chạy toàn app.
  final audioHandler = await AudioService.init(
    builder: () => MusicAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: AppConfig.androidNotificationChannelId,
      androidNotificationChannelName: AppConfig.androidNotificationChannelName,
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: AppConfig.supportedLocales,
      path: AppAssets.translationDir,
      fallbackLocale: AppConfig.fallbackLocale,
      startLocale: AppConfig.defaultLocale,
      child: ProviderScope(
        overrides: [audioHandlerProvider.overrideWithValue(audioHandler)],
        child: const MyApp(),
      ),
    ),
  );
}
