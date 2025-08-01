import 'dart:math';

import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  static const double textTitleBody = 20;
  static const double textTaskTitle = 16;
  static const double textTaskHint = 14;
  static const double textTitle = 24;
  static const double textBottomTab = 11;
  static const double buttonHeight = 45;

  static double fieldWidthRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 3 / 4;
    return width;
  }

  static const double itemIconReport = 30;
  static const double itemIcon = 40;
  static const double paddingMenu = 5;
  static const double paddingDashBoard = 15;
  static const double borderTile = 15;
  static const double textSizeSubBody = 18;
  static const double textSizeNote = 14;
  static const double textSizeTextMenu = 16;
}

class AppTextStyle {
  AppTextStyle._();

  static TextStyle dashboardTitle = const TextStyle(
    fontSize: AppSize.textTitle,
    fontWeight: FontWeight.bold,
  );

  static TextStyle textBodyTile({
    Color color = AppColor.primaryTextColor,
    FontWeight fontWeight = FontWeight.bold,
    double size = 22,
  }) {
    return TextStyle(fontSize: size, fontWeight: fontWeight, color: color);
  }

  static TextStyle textNote({
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: AppSize.textSizeNote,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textSizeTextMenu({
    required Color color,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: AppSize.textSizeTextMenu,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static TextStyle textHint(color) {
    return TextStyle(fontSize: AppSize.textTaskHint, color: color);
  }

  static TextStyle textTaskBody(Color color) {
    return TextStyle(fontSize: AppSize.textTitleBody, color: color);
  }

  static TextStyle textTaskTitle(Color color) {
    return TextStyle(
      fontSize: AppSize.textTaskTitle,
      color: color,
      fontWeight: FontWeight.bold,
    );
  }
}

class AppColor {
  AppColor._();

  static const primaryOverlay = Color(0xFFFFE4EC);
  static const primaryColor = Color(0xFFF8BBD0);
  static const primaryTextColor = Colors.black87;
  static const primaryTextColorTitle = Color(0xFFF06292);

  static const List<Color> projectColors = [
    Color(0xFFE3F2FD), // Light blue (Blue[50])
    Color(0xFFFFF9C4), // Light yellow (Yellow[100])
    Color(0xFFFFE0B2), // Light orange (Orange[100])
    Color(0xFFFFCDD2), // Light red/pink (Red[100])
    Color(0xFFF8BBD0), // Light pink
    Color(0xFFD1C4E9), // Light purple
    Color(0xFFC8E6C9), // Light green (Green[100])
    Color(0xFFB2EBF2), // Light cyan
    Color(0xFFFFF3E0), // Light creamy orange
    Color(0xFFDCEDC8), // Light lime green
  ];

  static const List<Color> taskColors = [
    Color(0xFF81C784), // Light green
    Color(0xFF64B5F6), // Light blue
    Color(0xFFFFB74D), // Light orange
    Color(0xFFE57373), // Light red
    Color(0xFFBA68C8), // Light purple
    Color(0xFFFF8A65), // Deep orange
    Color(0xFFA1887F), // Brown-gray
  ];

  static Color taskTileBoard = Colors.white;
  static Color projectTileAll = Colors.grey;

  static const List<Color> chartColors = [
    Color(0xFFB5EAEA), // Pastel Cyan
    Color(0xFFFFD6E8), // Pastel Pink
    Color(0xFFFFF5BA), // Pastel Yellow
    Color(0xFFBFD8B8), // Pastel Green
    Color(0xFFDAD4EF), // Pastel Purple
  ];
}

class ColorPool {
  final List<Color> _allColors;
  final List<Color> _availableColors = [];

  final Random _random = Random();

  ColorPool(this._allColors) {
    _availableColors.addAll(_allColors);
  }

  Color getNext() {
    if (_availableColors.isEmpty) {
      // Reset lại nếu đã dùng hết
      _availableColors.addAll(_allColors);
    }

    final index = _random.nextInt(_availableColors.length);
    final color = _availableColors[index];
    _availableColors.removeAt(index);
    return color;
  }
}

final ColorPool colorPool = ColorPool(AppColor.projectColors);
