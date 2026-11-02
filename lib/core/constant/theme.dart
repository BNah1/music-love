import 'package:flutter/material.dart';

import 'app_color.dart';

enum AppThemePreset {
  musicLove,
  gradient,
  snow,
  sunset,
  ocean,
  neon,
}

extension AppThemePresetX on AppThemePreset {
  String get value {
    switch (this) {
      case AppThemePreset.gradient:
        return 'gradient';
      case AppThemePreset.snow:
        return 'snow';
      case AppThemePreset.sunset:
        return 'sunset';
      case AppThemePreset.ocean:
        return 'ocean';
      case AppThemePreset.neon:
        return 'neon';
      case AppThemePreset.musicLove:
      return 'musicLove';
    }
  }

  String get label {
    switch (this) {
      case AppThemePreset.gradient:
        return 'Gradient';
      case AppThemePreset.snow:
        return 'Snow';
      case AppThemePreset.sunset:
        return 'Sunset';
      case AppThemePreset.ocean:
        return 'Ocean';
      case AppThemePreset.neon:
        return 'Neon';
      case AppThemePreset.musicLove:
      return 'Music Love';
    }
  }

  String get subtitle {
    switch (this) {
      case AppThemePreset.gradient:
        return 'Tím xanh chuyển màu mềm';
      case AppThemePreset.snow:
        return 'Trắng xanh nhẹ như tuyết';
      case AppThemePreset.sunset:
        return 'Cam hồng ấm như hoàng hôn';
      case AppThemePreset.ocean:
        return 'Xanh biển mát và sạch';
      case AppThemePreset.neon:
        return 'Đậm, nổi bật, cyber vibe';
      case AppThemePreset.musicLove:
      return 'Hồng nhẹ mặc định của app';
    }
  }

  IconData get icon {
    switch (this) {
      case AppThemePreset.gradient:
        return Icons.gradient_rounded;
      case AppThemePreset.snow:
        return Icons.ac_unit_rounded;
      case AppThemePreset.sunset:
        return Icons.wb_twilight_rounded;
      case AppThemePreset.ocean:
        return Icons.water_drop_rounded;
      case AppThemePreset.neon:
        return Icons.bolt_rounded;
      case AppThemePreset.musicLove:
      return Icons.favorite_rounded;
    }
  }

  List<Color> get previewColors {
    switch (this) {
      case AppThemePreset.gradient:
        return const [Color(0xFFE0C3FC), Color(0xFF8EC5FC)];
      case AppThemePreset.snow:
        return const [Color(0xFFFFFFFF), Color(0xFFDFF6FF)];
      case AppThemePreset.sunset:
        return const [Color(0xFFFF9A9E), Color(0xFFFAD0C4)];
      case AppThemePreset.ocean:
        return const [Color(0xFF43E97B), Color(0xFF38F9D7)];
      case AppThemePreset.neon:
        return const [Color(0xFFFF00CC), Color(0xFF00F5FF)];
      case AppThemePreset.musicLove:
      return const [Color(0xFFFFDEE9), Color(0xFFB5FFFC)];
    }
  }
}

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.preset,
    required this.backgroundGradient,
    required this.navIndicatorGradient,
    required this.musicCardGradient,
    required this.pageBackground,
    required this.cardBackground,
    required this.navBackground,
    required this.accentColor,
    required this.softAccentColor,
    required this.textColor,
    required this.subtitleColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.shadowColor,
  });

  final AppThemePreset preset;
  final LinearGradient backgroundGradient;
  final LinearGradient navIndicatorGradient;
  final LinearGradient musicCardGradient;
  final Color pageBackground;
  final Color cardBackground;
  final Color navBackground;
  final Color accentColor;
  final Color softAccentColor;
  final Color textColor;
  final Color subtitleColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final Color shadowColor;

  @override
  AppThemeExtension copyWith({
    AppThemePreset? preset,
    LinearGradient? backgroundGradient,
    LinearGradient? navIndicatorGradient,
    LinearGradient? musicCardGradient,
    Color? pageBackground,
    Color? cardBackground,
    Color? navBackground,
    Color? accentColor,
    Color? softAccentColor,
    Color? textColor,
    Color? subtitleColor,
    Color? selectedIconColor,
    Color? unselectedIconColor,
    Color? shadowColor,
  }) {
    return AppThemeExtension(
      preset: preset ?? this.preset,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      navIndicatorGradient: navIndicatorGradient ?? this.navIndicatorGradient,
      musicCardGradient: musicCardGradient ?? this.musicCardGradient,
      pageBackground: pageBackground ?? this.pageBackground,
      cardBackground: cardBackground ?? this.cardBackground,
      navBackground: navBackground ?? this.navBackground,
      accentColor: accentColor ?? this.accentColor,
      softAccentColor: softAccentColor ?? this.softAccentColor,
      textColor: textColor ?? this.textColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
      selectedIconColor: selectedIconColor ?? this.selectedIconColor,
      unselectedIconColor: unselectedIconColor ?? this.unselectedIconColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;

    return AppThemeExtension(
      preset: t < 0.5 ? preset : other.preset,
      backgroundGradient: t < 0.5 ? backgroundGradient : other.backgroundGradient,
      navIndicatorGradient: t < 0.5 ? navIndicatorGradient : other.navIndicatorGradient,
      musicCardGradient: t < 0.5 ? musicCardGradient : other.musicCardGradient,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      accentColor: Color.lerp(accentColor, other.accentColor, t)!,
      softAccentColor: Color.lerp(softAccentColor, other.softAccentColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
      selectedIconColor: Color.lerp(selectedIconColor, other.selectedIconColor, t)!,
      unselectedIconColor: Color.lerp(unselectedIconColor, other.unselectedIconColor, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
    );
  }
}

class AppTheme {
  static const Radius radiusLg = Radius.circular(24);
  static const Radius radiusMd = Radius.circular(12);
  static const Radius radiusSm = Radius.circular(8);

  static ThemeData lightTheme = themeData(
    preset: AppThemePreset.musicLove,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = themeData(
    preset: AppThemePreset.musicLove,
    brightness: Brightness.dark,
  );

  static ThemeMode themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static AppThemePreset presetFromString(String value) {
    for (final item in AppThemePreset.values) {
      if (item.value == value) return item;
    }
    return AppThemePreset.musicLove;
  }

  static AppThemeExtension extensionOf(BuildContext context) {
    final extension = Theme.of(context).extension<AppThemeExtension>();
    if (extension != null) return extension;

    return _themeExtension(
      preset: AppThemePreset.musicLove,
      brightness: Theme.of(context).brightness,
    );
  }

  static ThemeData themeData({
    required AppThemePreset preset,
    required Brightness brightness,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final AppThemeExtension appTheme = _themeExtension(
      preset: preset,
      brightness: brightness,
    );

    final baseTextTheme = isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: appTheme.accentColor,
      brightness: brightness,
      primary: appTheme.accentColor,
      secondary: appTheme.softAccentColor,
      surface: appTheme.cardBackground,
      background: appTheme.pageBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: appTheme.accentColor,
      primaryColorLight: isDark ? AppColors.grayscale1 : AppColors.grayscale8,
      primaryColorDark: isDark ? AppColors.grayscale4 : AppColors.grayscale5,
      canvasColor: appTheme.pageBackground,
      scaffoldBackgroundColor: appTheme.pageBackground,
      cardColor: appTheme.cardBackground,
      dividerColor: isDark ? Colors.white12 : Colors.black12,
      disabledColor: isDark ? Colors.white30 : Colors.black26,
      shadowColor: appTheme.shadowColor,
      unselectedWidgetColor: appTheme.unselectedIconColor,
      fontFamily: 'BeVietnamPro',
      extensions: <ThemeExtension<dynamic>>[
        appTheme,
      ],
      textTheme: baseTextTheme.apply(
        fontFamily: 'BeVietnamPro',
        bodyColor: appTheme.textColor,
        displayColor: appTheme.textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appTheme.pageBackground,
        foregroundColor: appTheme.textColor,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: appTheme.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'BeVietnamPro',
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: appTheme.navBackground,
        selectedItemColor: appTheme.selectedIconColor,
        unselectedItemColor: appTheme.unselectedIconColor,
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: appTheme.accentColor),
      primaryIconTheme: IconThemeData(color: appTheme.textColor),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: appTheme.accentColor,
        selectionColor: appTheme.accentColor.withOpacity(isDark ? 0.3 : 0.2),
        selectionHandleColor: appTheme.accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? appTheme.cardBackground : Colors.white,
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: appTheme.accentColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
        iconColor: appTheme.accentColor,
        prefixIconColor: appTheme.accentColor,
        suffixIconColor: appTheme.accentColor,
        focusColor: appTheme.softAccentColor,
        hoverColor: appTheme.softAccentColor.withOpacity(0.12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? Colors.white12 : Colors.black12;
            }
            return appTheme.accentColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? Colors.white38 : Colors.black38;
            }
            return appTheme.selectedIconColor;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(appTheme.accentColor),
          overlayColor: WidgetStateProperty.all(appTheme.softAccentColor.withOpacity(0.12)),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: isDark ? Colors.white30 : Colors.black26, width: 2);
            }
            return BorderSide(color: appTheme.accentColor, width: 2);
          }),
          foregroundColor: WidgetStateProperty.all<Color>(appTheme.accentColor),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? Colors.white10 : Colors.black12;
            }
            if (states.contains(WidgetState.pressed)) {
              return appTheme.softAccentColor.withOpacity(0.22);
            }
            return appTheme.cardBackground;
          }),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(appTheme.accentColor),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return appTheme.accentColor;
          return isDark ? Colors.white70 : Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) return appTheme.accentColor.withOpacity(0.35);
          return isDark ? Colors.white24 : Colors.black12;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(appTheme.accentColor),
        checkColor: WidgetStateProperty.all(appTheme.selectedIconColor),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: appTheme.accentColor,
        contentTextStyle: TextStyle(
          color: appTheme.selectedIconColor,
          fontFamily: 'BeVietnamPro',
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: appTheme.cardBackground,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: appTheme.accentColor,
        unselectedLabelColor: appTheme.subtitleColor,
        tabAlignment: TabAlignment.start,
        splashFactory: InkRipple.splashFactory,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: appTheme.accentColor,
              width: 4,
            ),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: appTheme.accentColor,
        linearTrackColor: appTheme.softAccentColor.withOpacity(0.18),
      ),
    );
  }

  static AppThemeExtension _themeExtension({
    required AppThemePreset preset,
    required Brightness brightness,
  }) {
    final bool isDark = brightness == Brightness.dark;

    switch (preset) {
      case AppThemePreset.gradient:
        return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF1B1234), Color(0xFF061A33)]
                : const [Color(0xFFF6EDFF), Color(0xFFEAF6FF)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          ),
          pageBackground: isDark ? const Color(0xFF111827) : const Color(0xFFF6F2FF),
          cardBackground: isDark ? const Color(0xFF1F2937) : Colors.white.withOpacity(0.92),
          navBackground: isDark ? const Color(0xDD1F2937) : Colors.white.withOpacity(0.82),
          accentColor: const Color(0xFF7C3AED),
          softAccentColor: const Color(0xFF8EC5FC),
          textColor: isDark ? Colors.white : const Color(0xFF151827),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF6B7280),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : const Color(0xFF64748B),
          shadowColor: const Color(0xFF8EC5FC).withOpacity(isDark ? 0.22 : 0.28),
        );
      case AppThemePreset.snow:
        return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                : const [Color(0xFFFFFFFF), Color(0xFFE9F8FF)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFFBDEBFF), Color(0xFF82D7FF)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFDFF6FF)],
          ),
          pageBackground: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4FBFF),
          cardBackground: isDark ? const Color(0xFF1E293B) : Colors.white.withOpacity(0.96),
          navBackground: isDark ? const Color(0xE61E293B) : Colors.white.withOpacity(0.9),
          accentColor: const Color(0xFF0284C7),
          softAccentColor: const Color(0xFFBAE6FD),
          textColor: isDark ? Colors.white : const Color(0xFF0F172A),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF64748B),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : const Color(0xFF64748B),
          shadowColor: const Color(0xFF0284C7).withOpacity(isDark ? 0.2 : 0.14),
        );
      case AppThemePreset.sunset:
        return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF271015), Color(0xFF3A1A0A)]
                : const [Color(0xFFFFF1EB), Color(0xFFFFE4EC)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFFB199)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
          ),
          pageBackground: isDark ? const Color(0xFF1F1415) : const Color(0xFFFFF4EF),
          cardBackground: isDark ? const Color(0xFF2A1B1C) : Colors.white.withOpacity(0.94),
          navBackground: isDark ? const Color(0xE62A1B1C) : Colors.white.withOpacity(0.84),
          accentColor: const Color(0xFFF97316),
          softAccentColor: const Color(0xFFFFB199),
          textColor: isDark ? Colors.white : const Color(0xFF24130F),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF7C4A3A),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : const Color(0xFF9A6B5B),
          shadowColor: const Color(0xFFF97316).withOpacity(isDark ? 0.22 : 0.18),
        );
      case AppThemePreset.ocean:
        return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF052E2B), Color(0xFF082F49)]
                : const [Color(0xFFE9FFF7), Color(0xFFE7F7FF)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          ),
          pageBackground: isDark ? const Color(0xFF061F2B) : const Color(0xFFF0FFFB),
          cardBackground: isDark ? const Color(0xFF102A36) : Colors.white.withOpacity(0.94),
          navBackground: isDark ? const Color(0xE6102A36) : Colors.white.withOpacity(0.84),
          accentColor: const Color(0xFF0891B2),
          softAccentColor: const Color(0xFF5EEAD4),
          textColor: isDark ? Colors.white : const Color(0xFF0F172A),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF52717A),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : const Color(0xFF52717A),
          shadowColor: const Color(0xFF0891B2).withOpacity(isDark ? 0.22 : 0.17),
        );
      case AppThemePreset.neon:
        return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF100014), Color(0xFF001F29)]
                : const [Color(0xFFFFF0FC), Color(0xFFE6FEFF)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFFFF00CC), Color(0xFF00F5FF)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFFFF00CC), Color(0xFF00F5FF)],
          ),
          pageBackground: isDark ? const Color(0xFF09090B) : const Color(0xFFFFF6FE),
          cardBackground: isDark ? const Color(0xFF18181B) : Colors.white.withOpacity(0.94),
          navBackground: isDark ? const Color(0xE618181B) : Colors.white.withOpacity(0.84),
          accentColor: const Color(0xFFDB2777),
          softAccentColor: const Color(0xFF22D3EE),
          textColor: isDark ? Colors.white : const Color(0xFF18181B),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF71717A),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : const Color(0xFF71717A),
          shadowColor: const Color(0xFFFF00CC).withOpacity(isDark ? 0.26 : 0.18),
        );
      case AppThemePreset.musicLove:
      return AppThemeExtension(
          preset: preset,
          backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [Color(0xFF21131C), Color(0xFF111827)]
                : const [Color(0xFFFFF7FB), Color(0xFFF0FBFF)],
          ),
          navIndicatorGradient: const LinearGradient(
            colors: [Color(0xFFE0C3FC), Color(0xFF8EC5FC)],
          ),
          musicCardGradient: const LinearGradient(
            colors: [Color(0xFFFFDEE9), Color(0xFFB5FFFC)],
          ),
          pageBackground: isDark ? const Color(0xFF161116) : const Color(0xFFF7F7FA),
          cardBackground: isDark ? const Color(0xFF241D25) : Colors.white,
          navBackground: isDark ? const Color(0xE6241D25) : Colors.white.withOpacity(0.82),
          accentColor: Colors.pinkAccent,
          softAccentColor: const Color(0xFFFFDEE9),
          textColor: isDark ? Colors.white : const Color(0xFF111827),
          subtitleColor: isDark ? Colors.white70 : const Color(0xFF7A7A7A),
          selectedIconColor: Colors.white,
          unselectedIconColor: isDark ? Colors.white60 : Colors.blueGrey.withOpacity(0.62),
          shadowColor: Colors.pink.withOpacity(isDark ? 0.22 : 0.08),
        );
    }
  }
}
