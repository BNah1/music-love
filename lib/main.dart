import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/audio/music_audio_handler.dart';
import 'core/provider/audio_handler_provider.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo local database.
  await Hive.initFlutter();

  await Hive.openBox('songs');
  await Hive.openBox('playlists');
  await Hive.openBox('player_cache');
  await Hive.openBox('settings');

  // Khởi tạo audio service chạy toàn app.
  final audioHandler = await AudioService.init(
    builder: () => MusicAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.musiclove.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: false,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const MyApp(),
    ),
  );
}


