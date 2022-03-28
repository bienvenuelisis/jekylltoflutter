import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jekylltoflutter/constants/themes.dart';

import '../services/local_storage.dart';

final appSettingsProvider = ChangeNotifierProvider((ref) => AppSettingsModel());

class AppSettingsModel extends ChangeNotifier {
  bool _nightMode = LocalStorage.nightMode;

  bool get nightMode => _nightMode;

  bool get loadImagesMainPostsAuto => LocalStorage.loadImagesMainPostsAuto;

  bool get loadImagesInPostsAuto => LocalStorage.loadImagesInPostsAuto;

  bool get loadVideosInPostsAuto => LocalStorage.loadVideosInPostsAuto;

  set loadImagesMainPostsAuto(bool loadImagesMainPostsAuto) {
    LocalStorage.loadImagesMainPostsAuto = loadImagesMainPostsAuto;

    notifyListeners();
  }

  set loadImagesInPostsAuto(bool loadImagesInPostsAuto) {
    LocalStorage.loadImagesInPostsAuto = loadImagesInPostsAuto;

    notifyListeners();
  }

  set loadVideosInPostsAuto(bool loadVideosInPostsAuto) {
    LocalStorage.loadVideosInPostsAuto = loadVideosInPostsAuto;

    notifyListeners();
  }

  set nightMode(bool nightMode) {
    _nightMode = nightMode;
    LocalStorage.nightMode = nightMode;

    notifyListeners();

    Themes.init(nightMode);
  }

  int get fontSize => LocalStorage.fontSize;

  set fontSize(int fontSize) {
    LocalStorage.fontSize = fontSize;

    notifyListeners();
  }

  bool get sendNotifications => LocalStorage.sendNotifications;

  set sendNotifications(bool sendNotifications) {
    LocalStorage.sendNotifications = sendNotifications;

    notifyListeners();
  }

  bool get keepFavorite => LocalStorage.keepFavorite;

  set keepFavorite(bool keepFavorite) {
    LocalStorage.keepFavorite = keepFavorite;

    notifyListeners();
  }

  int get favoriteDateDelay => LocalStorage.favoriteDeleteDelay;

  set favoriteDateDelay(int favoriteDateDelay) {
    LocalStorage.favoriteDeleteDelay = favoriteDateDelay;

    notifyListeners();
  }

  int get lastCategoryTabIndex => LocalStorage.lastCategoryTabIndex;

  set lastCategoryTabIndex(int lastCategoryTabIndex) {
    LocalStorage.lastCategoryTabIndex = lastCategoryTabIndex;

    notifyListeners();
  }

  AppSettingsModel();
}
