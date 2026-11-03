/// Centralized translation keys and app strings.
class AppString {
  AppString._();

  // App & Navigation
  static const String appName = 'app_name';
  static const String tabHome = 'tab_home';
  static const String tabLibrary = 'tab_library';
  static const String tabSettings = 'tab_settings';
  static const String tabSongs = 'tab_songs';
  static const String tabPlaylists = 'tab_playlists';

  // Home Screen
  static const String homeGreeting = 'home_greeting';
  static const String homeTitle = 'home_title';
  static const String homeSearchHint = 'home_search_hint';
  static const String homeSearchResults = 'home_search_results';
  static const String homePlaylists = 'home_playlists';
  static const String homeRecent = 'home_recent';
  static const String homeAllSongs = 'home_all_songs';
  static const String homeScanToFind = 'home_scan_to_find';
  static const String homeNoMatchingSongs = 'home_no_matching_songs';
  static const String homeEmpty = 'home_empty';
  static const String homeRetry = 'home_retry';
  static const String homeError = 'home_error';

  // Playlist Screen
  static const String playlistTitle = 'playlist_title';
  static const String playlistCreate = 'playlist_create';
  static const String playlistNameHint = 'playlist_name_hint';
  static const String playlistEmpty = 'playlist_empty';
  static const String playlistNoSongs = 'playlist_no_songs';
  static const String playlistNotFound = 'playlist_not_found';
  static const String playlistSongsCount = 'playlist_songs_count';
  static const String playlistRename = 'playlist_rename';
  static const String playlistDelete = 'playlist_delete';
  static const String playlistConfirmDelete = 'playlist_confirm_delete';
  static const String playlistRenamed = 'playlist_renamed';
  static const String playlistDeleted = 'playlist_deleted';
  static const String playlistAddTo = 'playlist_add_to';
  static const String playlistChooseSave = 'playlist_choose_save';
  static const String playlistNoPlaylistsYet = 'playlist_no_playlists_yet';
  static const String playlistAdded = 'playlist_added';
  static const String playlistRemoved = 'playlist_removed';

  // Context Menu & Actions
  static const String menuRename = 'menu_rename';
  static const String menuDelete = 'menu_delete';
  static const String menuAddToPlaylist = 'menu_add_to_playlist';
  static const String menuMoveToTop = 'menu_move_to_top';
  static const String menuMoveUp = 'menu_move_up';
  static const String menuMoveDown = 'menu_move_down';
  static const String menuMoveToBottom = 'menu_move_to_bottom';
  static const String menuRemoveFromPlaylist = 'menu_remove_from_playlist';

  // Music Player
  static const String playerNowPlaying = 'player_now_playing';
  static const String playerBack = 'player_back';
  static const String playerUnknownSong = 'player_unknown_song';
  static const String playerUnknownArtist = 'player_unknown_artist';
  static const String playerPlay = 'player_play';
  static const String playerPause = 'player_pause';
  static const String playerNext = 'player_next';
  static const String playerPrevious = 'player_previous';
  static const String playerCacheCleared = 'player_cache_cleared';
  static const String errorOpenSong = 'error_open_song';

  // Settings Screen
  static const String settingsTitle = 'settings_title';
  static const String settingsTheme = 'settings_theme';
  static const String settingsBluetooth = 'settings_bluetooth';
  static const String settingsLibrary = 'settings_library';
  static const String settingsPlayer = 'settings_player';
  static const String settingsLanguage = 'settings_language';
  static const String settingsLanguageDesc = 'settings_language_desc';
  static const String settingsVietnamese = 'settings_vietnamese';
  static const String settingsEnglish = 'settings_english';

  // Settings Theme
  static const String settingsThemeSystem = 'settings_theme_system';
  static const String settingsThemeSystemDesc = 'settings_theme_system_desc';
  static const String settingsThemeLight = 'settings_theme_light';
  static const String settingsThemeLightDesc = 'settings_theme_light_desc';
  static const String settingsThemeDark = 'settings_theme_dark';
  static const String settingsThemeDarkDesc = 'settings_theme_dark_desc';

  // Settings Library
  static const String settingsLibraryAutoScan = 'settings_library_auto_scan';
  static const String settingsLibraryAutoScanDesc =
      'settings_library_auto_scan_desc';
  static const String settingsLibraryScanHidden =
      'settings_library_scan_hidden';
  static const String settingsLibraryScanHiddenDesc =
      'settings_library_scan_hidden_desc';
  static const String settingsLibrarySort = 'settings_library_sort';
  static const String settingsLibraryRestore = 'settings_library_restore';
  static const String settingsLibraryRestoreDesc =
      'settings_library_restore_desc';
  static const String settingsLibraryRestored = 'settings_library_restored';

  // Library Sorting options
  static const String settingsSortName = 'settings_sort_name';
  static const String settingsSortArtist = 'settings_sort_artist';
  static const String settingsSortDate = 'settings_sort_date';
  static const String settingsSortDuration = 'settings_sort_duration';

  // Settings Bluetooth / Headphone
  static const String settingsBluetoothAutoplay = 'settings_bluetooth_autoplay';
  static const String settingsBluetoothAutoplayDesc =
      'settings_bluetooth_autoplay_desc';
  static const String settingsBluetoothPause = 'settings_bluetooth_pause';
  static const String settingsBluetoothPauseDesc =
      'settings_bluetooth_pause_desc';
  static const String settingsBluetoothDeviceName =
      'settings_bluetooth_device_name';
  static const String settingsBluetoothDeviceNameDesc =
      'settings_bluetooth_device_name_desc';

  // Settings Music Player
  static const String settingsPlayerResume = 'settings_player_resume';
  static const String settingsPlayerResumeDesc = 'settings_player_resume_desc';
  static const String settingsPlayerDefaultShuffle =
      'settings_player_default_shuffle';
  static const String settingsPlayerDefaultShuffleDesc =
      'settings_player_default_shuffle_desc';
  static const String settingsPlayerDefaultRepeat =
      'settings_player_default_repeat';
  static const String settingsPlayerKeepNotification =
      'settings_player_keep_notification';
  static const String settingsPlayerKeepNotificationDesc =
      'settings_player_keep_notification_desc';
  static const String settingsPlayerClearCache = 'settings_player_clear_cache';
  static const String settingsPlayerClearCacheDesc =
      'settings_player_clear_cache_desc';

  // Repeat modes
  static const String repeatNone = 'repeat_none';
  static const String repeatAll = 'repeat_all';
  static const String repeatOne = 'repeat_one';

  // Common actions
  static const String commonCancel = 'common_cancel';
  static const String commonSave = 'common_save';
  static const String commonDelete = 'common_delete';
  static const String commonCreate = 'common_create';
  static const String commonClose = 'common_close';
}
