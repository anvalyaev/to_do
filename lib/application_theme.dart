import 'package:flutter/material.dart';

class ApplicationThemeData {
  static ThemeData themeData() {
    return new ThemeData(
      brightness: Brightness.light,
      primaryColorDark: Color(0xFF5D4037),
      primaryColorLight: Color(0xFFD7CCC8),
      primaryColor: Color(0xFF795548),
      accentColor: Color(0xFFFFC107),
      dividerColor: Color(0xFFBDBDBD),
    );
  }
}
