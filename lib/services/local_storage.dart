import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/styles.dart';
import '../constants/themes.dart';
import '../models/article.dart';

class LocalStorage {
  static late SharedPreferences localStorage;

  static const String _firstAppUseKey = "firstAppUseKey";

  static const String _nightModeKey = "nightModeKey";

  static const String _fontSizeKey = "fontSizeKey";

  static const String _lockedPremiumArticlesKey = "lockedPremiumArticlesKey";

  static const String _dataUsageInBytesKey = "dataUsageInBytesKey";

  static const String _toReadLaterKey = "toReadLaterKey";

  static const String _searchHistoryKey = "searchHistoryKey";

  static const String _keepFavoritesKey = "keepFavoritesKey";

  static const String _deleteFavoriteAutoAfterDelayKey =
      "deleteFavoriteAutoAfterDelayKey";

  static const String _favoritesPostsKey = "favoritesPostsKey";

  static const String _loadImagesMainPostsAutoKey =
      "loadImagesMainPostsAutoKey";

  static const String _loadVideosInPostsAutoKey = "loadVideosInPostsAutoKey";

  static const String _loadImagesInPostsAutoKey = "loadImagesInPostsAutoKey";

  static const String _sendNotificationsKey = "sendNotificationsKey";

  static const String _lastCategoryTabIndexKey = "lastCategoryTabIndexKey";

  static const String _dateFirstAppUseKey = "dateFirstAppUseKey";

  static late final Directory appDocDir;

  static Future<bool> init() async {
    localStorage = await SharedPreferences.getInstance();
    appDocDir = await getApplicationDocumentsDirectory();
    return true;
  }

  static DateTime dateFirstUsage() {
    if (isFirstAppUse()) {
      return DateTime.now();
    } else {
      try {
        String? dateFr = localStorage.getString(_dateFirstAppUseKey);
        if (dateFr == null || dateFr.isEmpty) {
          DateTime date = DateTime.now();
          localStorage.setString(_dateFirstAppUseKey, date.toIso8601String());
          return date;
        } else {
          return DateTime.parse(dateFr);
        }
      } on FormatException {
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }
  }

  static void setAppFirstUsage() {
    localStorage.setBool(_firstAppUseKey, false);
  }

  static bool isFirstAppUse() {
    if (localStorage.containsKey(_firstAppUseKey)) {
      return localStorage.getBool(_firstAppUseKey) ?? true;
    } else {
      return true;
    }
  }

  static bool boolStorage(
    String key, [
    bool defaultValue = false,
    bool setDefaultValue = true,
  ]) {
    if (localStorage.containsKey(key)) {
      return localStorage.getBool(key)!;
    } else {
      if (setDefaultValue) {
        localStorage.setBool(key, defaultValue);
      }
      return defaultValue;
    }
  }

  static int intStorage(
    String key, [
    int defaultValue = 0,
    bool setDefaultValue = true,
  ]) {
    if (localStorage.containsKey(key)) {
      return localStorage.getInt(key)!;
    } else {
      if (setDefaultValue) {
        localStorage.setInt(key, defaultValue);
      }
      return defaultValue;
    }
  }

  static void incrStorage(String key) {
    localStorage.setInt(key, (intStorage(key, 0, false) + 1));
  }

  static void decrStorage(String key) {
    localStorage.setInt(key, (intStorage(key, 0, false) - 1));
  }

  static bool containsShPrefs(String key, String value) {
    return listFromShPrefs(key).contains(value.toLowerCase());
  }

  static bool get nightMode {
    if (localStorage.containsKey(_nightModeKey)) {
      return localStorage.getBool(_nightModeKey) ?? false;
    } else {
      localStorage.setBool(_nightModeKey, false);
      return false;
    }
  }

  static set nightMode(bool value) {
    localStorage.setBool(_nightModeKey, value);
    Themes.init(value);
  }

  static set keepFavorite(bool keepFavorite) {
    localStorage.setBool(_keepFavoritesKey, keepFavorite);
  }

  static bool get keepFavorite {
    if (localStorage.containsKey(_keepFavoritesKey)) {
      return localStorage.getBool(_keepFavoritesKey) ?? false;
    } else {
      localStorage.setBool(_keepFavoritesKey, true);
      return true;
    }
  }

  static set favoriteDeleteDelay(int favoriteDeleteDelay) {
    localStorage.setInt(_deleteFavoriteAutoAfterDelayKey, favoriteDeleteDelay);
  }

  static int get favoriteDeleteDelay {
    if (localStorage.containsKey(_deleteFavoriteAutoAfterDelayKey)) {
      return localStorage.getInt(_deleteFavoriteAutoAfterDelayKey) ?? 0;
    } else {
      localStorage.setInt(_deleteFavoriteAutoAfterDelayKey, 0);
      return 0;
    }
  }

  static bool isFavorite(String id) {
    return containsShPrefs(_favoritesPostsKey, id);
  }

  static bool isReadLaterArticle(String id) {
    return containsShPrefs(_toReadLaterKey, id);
  }

  static set lastCategoryTabIndex(int index) {
    localStorage.setInt(_lastCategoryTabIndexKey, index);
  }

  static int get lastCategoryTabIndex {
    if (localStorage.containsKey(_lastCategoryTabIndexKey)) {
      return localStorage.getInt(_lastCategoryTabIndexKey) ?? 0;
    } else {
      localStorage.setInt(_lastCategoryTabIndexKey, 0);
      return 0;
    }
  }

  static List<String> get getFavoritesPosts {
    return listFromShPrefs(_favoritesPostsKey);
  }

  static List<String> get getToReadLaterPosts {
    return listFromShPrefs(_toReadLaterKey);
  }

  static void addToSearchHistory(String search) {
    addToListShPrefs(_searchHistoryKey, search);
  }

  static List<String> get getSearchHistory {
    return listFromShPrefs(_searchHistoryKey);
  }

  static void addToFavoritesPosts(Article article) {
    addToListShPrefs(_favoritesPostsKey, article.id.toString());
  }

  static void addToReadLaterArticles(Article article) {
    addToListShPrefs(_toReadLaterKey, article.id.toString());
  }

  static void removeFromFavoritesPosts(Article article) {
    removeFromListShPrefs(_favoritesPostsKey, article.id.toString());
  }

  static void removeFromReadLaterArticles(Article article) {
    removeFromListShPrefs(_toReadLaterKey, article.id.toString());
  }

  static set loadImagesMainPostsAuto(bool value) {
    localStorage.setBool(_loadImagesMainPostsAutoKey, value);
  }

  static set loadVideosInPostsAuto(bool value) {
    localStorage.setBool(_loadVideosInPostsAutoKey, value);
  }

  static set loadImagesInPostsAuto(bool value) {
    localStorage.setBool(_loadImagesInPostsAutoKey, value);
  }

  static bool get loadImagesMainPostsAuto {
    if (localStorage.containsKey(_loadImagesMainPostsAutoKey)) {
      return localStorage.getBool(_loadImagesMainPostsAutoKey) ?? true;
    } else {
      localStorage.setBool(_loadImagesMainPostsAutoKey, true);
      return true;
    }
  }

  static bool get loadVideosInPostsAuto {
    if (localStorage.containsKey(_loadVideosInPostsAutoKey)) {
      return localStorage.getBool(_loadVideosInPostsAutoKey) ?? true;
    } else {
      localStorage.setBool(_loadVideosInPostsAutoKey, true);
      return false;
    }
  }

  static bool get loadImagesInPostsAuto {
    if (localStorage.containsKey(_loadImagesInPostsAutoKey)) {
      return localStorage.getBool(_loadImagesInPostsAutoKey) ?? true;
    } else {
      localStorage.setBool(_loadImagesInPostsAutoKey, true);
      return true;
    }
  }

  static set sendNotifications(bool sendNotifications) {
    localStorage.setBool(_sendNotificationsKey, sendNotifications);
  }

  static bool get sendNotifications {
    if (localStorage.containsKey(_sendNotificationsKey)) {
      return localStorage.getBool(_sendNotificationsKey) ?? true;
    } else {
      localStorage.setBool(_sendNotificationsKey, true);
      return true;
    }
  }

  static set fontSize(int fontSize) {
    localStorage.setInt(_fontSizeKey, fontSize);
  }

  static int get fontSize {
    if (localStorage.containsKey(_fontSizeKey)) {
      return localStorage.getInt(_fontSizeKey) ?? 15;
    } else {
      localStorage.setInt(_fontSizeKey, defaultFontSize);
      return defaultFontSize;
    }
  }

  static bool lockedPremiumArticle(Article article) {
    return !containsShPrefs(
      _lockedPremiumArticlesKey,
      article.url.toString(),
    );
  }

  static bool premiumContentIsLocked(String identifier) {
    return !containsShPrefs(
      _lockedPremiumArticlesKey,
      identifier.toString(),
    );
  }

  static void dataUse(int dataUseInBytes) {
    localStorage.setInt(
      _dataUsageInBytesKey,
      getDateUsageBytes + dataUseInBytes,
    );
  }

  // ignore: unused_element
  static void _resetDataUsage() {
    localStorage.setInt(_dataUsageInBytesKey, 0);
  }

  static int get getDateUsageBytes {
    if (localStorage.containsKey(_dataUsageInBytesKey)) {
      return localStorage.getInt(_dataUsageInBytesKey) ?? 0;
    } else {
      localStorage.setInt(_dataUsageInBytesKey, 0);
      return 0;
    }
  }

  static List<String> listFromShPrefs(String key) {
    if (localStorage.containsKey(key)) {
      List<String>? listShPrefs = localStorage.getStringList(key);
      return listShPrefs ?? [];
    } else {
      return [];
    }
  }

  static void addToListShPrefs(String key, String? toAdd) {
    List<String> list = listFromShPrefs(key);
    if (toAdd != null &&
        toAdd.isNotEmpty &&
        !list.contains(toAdd.toLowerCase())) {
      list.add(toAdd.toLowerCase());
      localStorage.setStringList(key, list);
    }
  }

  static void removeFromListShPrefs(String key, String? toRemove) {
    List<String> list = listFromShPrefs(key);
    if (toRemove != null &&
        toRemove.isNotEmpty &&
        containsShPrefs(key, toRemove)) {
      list.remove(toRemove.toLowerCase());
      localStorage.setStringList(key, list);
    }
  }
}
