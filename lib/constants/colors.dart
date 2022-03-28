import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor main = Colors.teal;

  static Brightness bright([bool offline = false]) {
    return offline ? Brightness.dark : Brightness.light;
  }

  static Color? mainColor([bool offline = false]) {
    return offline ? Colors.teal[500] : Colors.teal;
  }
}