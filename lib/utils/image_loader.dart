
import 'package:flutter/material.dart';

class ImageLoading {
  static Widget imgPlaceHolder({
    Color from = Colors.grey,
    Color to = Colors.black,
    bool rounded = true,
    BorderRadius radius = const BorderRadius.all(
      Radius.circular(5),
    ),
  }) {
    return rounded
        ? Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.4, 1],
                colors: [from, to],
              ),
              borderRadius: radius,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.4, 1],
                colors: [from, to],
              ),
            ),
          );
  }
}
