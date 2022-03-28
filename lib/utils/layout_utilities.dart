import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class LayoutUtils {
  static Widget iconText(Icon icon, Text text) {
    return Row(
      children: [icon, const SizedBox(width: 5), text],
    );
  }
}

class ImageUtils {
  static String articleRandomPlaceholder() {
    return "assets/${Random().nextInt(4) + 1}.jpg";
  }

  /* Widget _imgLoading(double height, double width) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1],
                colors: [Colors.grey, Colors.black]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )));
  } */
}
