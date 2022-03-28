import 'package:flutter/material.dart';

import '../utils/image_loader.dart';

class Images {
  static Widget network(
    String url, {
    double? width,
    double? height,
    BoxFit? fit,
    bool usePlaceHolder = false,
    Widget? loader,
    Widget? error,
    Widget? placeHolder,
  }) {
    return usePlaceHolder
        ? (placeHolder ?? ImageLoading.imgPlaceHolder())
        : Image.network(
            url,
            fit: fit,
            height: height,
            width: width,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return loader ?? CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    );
            },
          );
  }
}
