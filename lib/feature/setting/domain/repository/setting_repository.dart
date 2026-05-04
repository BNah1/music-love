import 'package:hive/hive.dart';

class SettingRepository {
  final Box box = Hive.box('settings');

  bool getBool(String key, {bool defaultValue = false}) {
    return box.get(key, defaultValue: defaultValue) as bool;
  }

  String getString(String key, {String defaultValue = ''}) {
    return box.get(key, defaultValue: defaultValue) as String;
  }

  Future<void> setBool(String key, bool value) async {
    await box.put(key, value);
  }

  Future<void> setString(String key, String value) async {
    await box.put(key, value);
  }
}

class SettingKeys {
  static const String themeMode = 'themeMode';
  static const String themeStyle = 'themeStyle';

  static const String autoPlayWhenHeadphoneConnected =
      'autoPlayWhenHeadphoneConnected';
  static const String pauseWhenHeadphoneDisconnected =
      'pauseWhenHeadphoneDisconnected';
  static const String showBluetoothDeviceName = 'showBluetoothDeviceName';

  static const String autoScanLibrary = 'autoScanLibrary';
  static const String scanHiddenFiles = 'scanHiddenFiles';
  static const String librarySortType = 'librarySortType';

  static const String resumeLastSong = 'resumeLastSong';
  static const String defaultShuffle = 'defaultShuffle';
  static const String defaultRepeat = 'defaultRepeat';
  static const String keepNotificationWhenPause = 'keepNotificationWhenPause';
}