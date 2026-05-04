import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static const Radius radiusLg = Radius.circular(24);

  /// Medium circular radius: 12
  static const Radius radiusMd = Radius.circular(12);

  /// Small circular radius: 8
  static const Radius radiusSm = Radius.circular(8);

  static ThemeData lightTheme = ThemeData(
    // 🔆 Chế độ sáng hoặc tối
    brightness: Brightness.light,

    // 🎨 Màu sắc chính
    primaryColor: AppColors.primary5,
    primaryColorLight: AppColors.grayscale8,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary5, brightness: Brightness.light),

    primaryColorDark: AppColors.grayscale5,
    canvasColor: AppColors.grayscale1,
    scaffoldBackgroundColor: AppColors.grayscale1,
    cardColor: AppColors.grayscale1,
    dividerColor: AppColors.grayscale3,
    disabledColor: AppColors.grayscale5,
    shadowColor: AppColors.grayscale8.withOpacity(0.25),
    unselectedWidgetColor: AppColors.grayscale5,
    fontFamily: 'BeVietnamPro',

    // 📌 AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary5,
      foregroundColor: AppColors.grayscale1,
      elevation: 0,
      centerTitle: true,
    ),


    // 📱 Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.grayscale1,
      selectedItemColor: AppColors.primary5,
      unselectedItemColor: AppColors.grayscale5,

      elevation: 0,
    ),

    // 🎭 Icon
    iconTheme: IconThemeData(color: AppColors.primary5),
    primaryIconTheme: IconThemeData(color: AppColors.grayscale8),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary5,
      selectionColor: AppColors.primary5.withOpacity(0.2),
      selectionHandleColor: AppColors.primary5,
    ),
    //TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grayscale1,
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      alignLabelWithHint: true,


      // Borders
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale3),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale3),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary5),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale3),
      ),

      // Icon colors
      iconColor: AppColors.primary5,
      prefixIconColor: AppColors.primary5,
      suffixIconColor: AppColors.primary5,

      // Focus/hover behavior
      focusColor: AppColors.primary1,
      hoverColor: AppColors.primary1.withOpacity(0.04),
    ),
    // 🖱 Nút bấm
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale3; // Màu khi bị vô hiệu hóa
          }
          return AppColors.primary5; // Màu bình thường
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale5; // Màu chữ khi bị vô hiệu hóa
          }
          return AppColors.grayscale1; // Màu chữ bình thường
        }),

        // 🔲 Hình dạng
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent), // Màu nền
        foregroundColor: WidgetStateProperty.all(AppColors.primary5), // Màu chữ
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(AppColors.grayscale8.withOpacity(0.25)),

        elevation: WidgetStateProperty.all(0),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        // 🎨 Màu viền
        side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: AppColors.grayscale5,
              width: 2,
            ); // Khi bị vô hiệu hóa
          }

          return BorderSide(
            color: AppColors.primary5,
            width: 2,
          ); // Bình thường
        }),

        // 🎨 Màu chữ
        foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed)) {
            return AppColors.grayscale1;
          }
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale5;
          }
          return AppColors.primary5;
        }),

        // 🖋 Kiểu chữ

        // 🏞 Màu nền
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale2; // Nền trong suốt khi bị vô hiệu hóa
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary3; // Khi nhấn có hiệu ứng nền
          }
          return AppColors.grayscale1; // Bình thường không có nền
        }),

        // 🔲 Hình dạng
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),

    //Icon Button
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent), // Màu nền
        foregroundColor: WidgetStateProperty.all(AppColors.primary5), // Màu icon
        elevation: WidgetStateProperty.all(0), // Không có bóng
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bo góc button
          ),
        ),
        // padding: WidgetStateProperty.all(
        //   EdgeInsets.all(12), // Khoảng cách padding đồng đều
        // ),
        alignment: Alignment.center, // Căn giữa icon trong button
      ),
    ),

    //TextButton

    // 🎚 Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary5),
      trackColor: WidgetStateProperty.all(AppColors.grayscale3),
    ),

    // ✅ Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary5),
      checkColor: WidgetStateProperty.all(AppColors.grayscale1),
    ),

    // 🍞 SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary5,
      contentTextStyle: TextStyle(color: AppColors.grayscale1),
    ),

    // 🗨️ Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.grayscale1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    // 📎 TabBar
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary5,
      unselectedLabelColor: AppColors.grayscale5,
      tabAlignment: TabAlignment.start,
      splashFactory: InkRipple.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
            bottom: BorderSide(
              color: AppColors.primary5,
              width: 4,
            )),
      ),
    ),

    // ⏳ Progress Indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary5,
      linearTrackColor: AppColors.primary5,
    ),
  );

  /// 🌙 **Chế độ tối (Dark Theme)**
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    // 🎨 Màu sắc chính
    primaryColor: AppColors.primary5,
    primaryColorLight: AppColors.grayscale1,
    primaryColorDark: AppColors.grayscale4,
    canvasColor: AppColors.grayscale8,
    scaffoldBackgroundColor: AppColors.grayscale8,
    cardColor: AppColors.grayscale8,
    dividerColor: AppColors.grayscale3,
    disabledColor: AppColors.grayscale5,
    shadowColor: AppColors.grayscale1.withOpacity(0.25),
    unselectedWidgetColor: AppColors.grayscale5,
    fontFamily: 'BeVietnamPro',

    // 📌 AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary5,
      foregroundColor: AppColors.grayscale1,
      elevation: 0,
      centerTitle: true,
    ),

    // 📱 Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.grayscale8,
      selectedItemColor: AppColors.primary5,
      unselectedItemColor: AppColors.grayscale5,
      selectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.primary5,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.grayscale5,
      ),
      elevation: 0,
    ),

    // 🎭 Icon
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary5,
      selectionColor: AppColors.primary5.withOpacity(0.3),
      selectionHandleColor: AppColors.primary5,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grayscale8, // nền input trong dark
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      alignLabelWithHint: true,

      contentPadding: EdgeInsets.symmetric(
      ),


      // Borders
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale4),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary5, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grayscale3),
      ),

      // Icon colors
      iconColor: AppColors.primary5,
      prefixIconColor: AppColors.primary5,
      suffixIconColor: AppColors.primary5,

      // Focus/hover behavior
      focusColor: AppColors.primary1,
      hoverColor: AppColors.primary1.withOpacity(0.1),
    ),
    // 🖱 Nút bấm
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale3;
          }
          return AppColors.primary5;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale5;
          }
          return AppColors.grayscale1;
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
        foregroundColor: WidgetStateProperty.all(AppColors.primary5),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.resolveWith<BorderSide>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: AppColors.grayscale5, width: 2);
          }
          return BorderSide(color: AppColors.primary5, width: 2);
        }),
        foregroundColor: WidgetStateProperty.all<Color>(AppColors.grayscale1),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.grayscale2;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primary3;
          }
          return AppColors.grayscale8;
        }),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    ),

    // 🎚 Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary5),
      trackColor: WidgetStateProperty.all(AppColors.grayscale3),
    ),

    // ✅ Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary5),
      checkColor: WidgetStateProperty.all(AppColors.grayscale1),
    ),

    // 🍞 SnackBar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.primary5,
      contentTextStyle: TextStyle(color: AppColors.grayscale1),
    ),

    // 🗨️ Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.grayscale8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    // 📎 TabBar
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primary5,
      unselectedLabelColor: AppColors.grayscale5,
      tabAlignment: TabAlignment.start,
      splashFactory: InkRipple.splashFactory,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary5, width: 4),
        ),
      ),
    ),

    // ⏳ Progress Indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primary5,
      linearTrackColor: AppColors.grayscale1,
    ),
  );
}
