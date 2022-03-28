import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';

class Themes {
  static final ThemeData light = ThemeData(
    primarySwatch: Colors.teal,
    accentColor: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: Colors.white,
    textTheme: const TextTheme(headline6: TextStyle(color: Colors.black87)),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF222D36),
      // ignore: unnecessary_const
      titleTextStyle: const TextStyle(
        color: Colors.white70,
      ),
    ),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    backgroundColor: const Color(0xFF101D24),
    scaffoldBackgroundColor: const Color(0xFF101D24),
    /* backgroundColor: Colors.black54,
    scaffoldBackgroundColor: Colors.grey[900], */
    primarySwatch: Colors.teal,
    accentColor: Colors.teal,
    textTheme: const TextTheme(headline6: TextStyle(color: Colors.white70)),
  );

  static SettingsThemeData settingsDarkTheme = const SettingsThemeData();

  static SettingsThemeData settingsLightTheme = const SettingsThemeData();

  static void init([bool darkMode = true]) {
    Get.changeTheme(darkMode ? dark : light);
  }
}
