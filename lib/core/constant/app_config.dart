import 'package:flutter/material.dart';

/// Centralized application configuration constants.
class AppConfig {
  AppConfig._();

  static const String appName = 'Music Love';
  static const String appVersion = '1.0.0';

  // Localization
  static const Locale defaultLocale = Locale('vi');
  static const Locale fallbackLocale = Locale('vi');
  static const List<Locale> supportedLocales = [Locale('vi'), Locale('en')];

  // Audio Service & Notifications
  static const String androidNotificationChannelId = 'com.musiclove.audio';
  static const String androidNotificationChannelName = 'Music playback';

  // Hive Box Names
  static const String boxSongs = 'songs';
  static const String boxPlaylists = 'playlists';
  static const String boxPlayerCache = 'player_cache';
  static const String boxSettings = 'settings';
}
