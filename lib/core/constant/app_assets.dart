/// Centralized asset path constants for the application.
class AppAssets {
  AppAssets._();

  // Root directories
  static const String iconsDir = 'assets/icons/';
  static const String translationDir = 'assets/translation';

  // Playback control SVG icons
  static const String nextButton = 'assets/icons/next_button.svg';
  static const String backButton = 'assets/icons/back_button.svg';
  static const String pauseButton = 'assets/icons/pause_button.svg';
  static const String playButton = 'assets/icons/play_button.svg';

  // Translation JSON paths
  static const String translationVi = 'assets/translation/vi.json';
  static const String translationEn = 'assets/translation/en.json';

  /// Standard play/pause control icons list
  static const List<String> playMusicIcons = [
    nextButton,
    backButton,
    pauseButton,
    playButton,
  ];
}
