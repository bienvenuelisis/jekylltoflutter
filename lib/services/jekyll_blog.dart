import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'config.dart';
import '../models/index.dart';
import 'local_storage.dart';
import 'objects.dart';

class JekyllBlog {
  static Blog? _blog;

  static JekyllConfig? _config;

  static List<Article>? _articles;

  static List<Article> get articles => _articles ?? [];

  static Set<String>? _categories;

  static Set<String> get categories => _categories ?? {};

  static Set<Author>? _authors;

  static Set<Author> get authors => _authors ?? {};

  static Set<String>? _tags;

  static Set<String> get tags => _tags ?? {};

  static String get baseUrl =>
      _config!.getString("url").replaceFirst(RegExp(r"/$"), "");

  static String get description => _config!.getString("description");

  static String get name => _config!.getString("name");

  static String get instagram => _config!.getString("instagram");

  static String get twitter => _config!.getString("twitter");

  static String get github => _config!.getString("github");

  static String get email => _config!.getString("email");

  static String get facebook => _config!.getString("facebook");

  static String get phoneNumber => _config!.getString("phone_number");

  static String get featuredTag => _config!.getString("featured_tag");

  static String get postsApi => _config!.getString("posts_api");

  static List<Article> fromAuthor(
    Author author, {
    int? limit,
    List<Article>? excludes,
  }) {
    List<Article> fromAuthor = articles
        .where((article) => article.author?.name == author.name)
        .toList();

    if (excludes != null) {
      fromAuthor.removeWhere((article) => excludes.contains(article));
    }

    return limit == null || fromAuthor.length < limit
        ? fromAuthor
        : fromAuthor.sublist(0, limit);
  }

  static List<Article> thisDate(
    Article article, {
    int? limit,
    List<Article>? excludes,
  }) {
    List<Article> thisDate = articles
        .where((a) => article.dateEn.complete == a.dateEn.complete)
        .toList();

    if (excludes != null) {
      thisDate.removeWhere((article) => excludes.contains(article));
    }

    return limit == null || thisDate.length < limit
        ? thisDate
        : thisDate.sublist(0, limit);
  }

  static Article getArticle(String articleId) {
    return articles.firstWhere((article) => article.id == articleId);
  }

  static List<Article> get favoritesPosts {
    return LocalStorage.getFavoritesPosts.map((id) => getArticle(id)).toList();
  }

  static List<Article> get bookmarksPosts {
    return LocalStorage.getToReadLaterPosts
        .map((id) => getArticle(id))
        .toList();
  }

  static List<Article> searchArticle(String search) {
    return articles.where((a) => searchArticleFunc(a, search)).toList();
  }

  static File get backUpFile {
    return File(join(LocalStorage.appDocDir.path, "$name.json"));
  }

  static bool get hasBackUp {
    return backUpFile.existsSync();
  }

  static Future<bool> restoreBackUp() async {
    if (_blog == null && hasBackUp) {
      try {
        _blog = Blog.fromJson(
          jsonDecode(
            jsonDecode(
              (await backUpFile.readAsString()),
            ),
          ),
        );

        if (_blog != null && _blog!.posts.isNotEmpty) {
          _generateBlogContents();
          return true;
        } else {
          return false;
        }
      } catch (e) {
        debugPrint(e.toString());
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<void> createBackUp(http.Response blog) async {
    await backUpFile.create(recursive: true);
    await backUpFile.writeAsString(json.encode(blog.body));
  }

  static Future<bool> startup() async {
    _config = await JekyllConfig.instance;

    return _config?.has("url") ?? false;
  }

  static Future<bool> init() async {
    try {
      var request = await http.get(
        Uri.parse(baseUrl + postsApi),
        headers: {"Accept": "Application/json"},
      );

      _blog = ResponseData<Blog>(
        message: "Blog Posts fetched",
        data: Blog.fromJson(jsonDecode(request.body)),
      ).data;

      if (_blog != null && _blog!.posts.isNotEmpty) {
        //Backup is done in background.
        //If error remove Future.delayed.
        _generateBlogContents();

        Future.delayed(const Duration(seconds: 15)).then(
          (_) {
            LocalStorage.dataUse(request.contentLength ?? 0);

            try {
              createBackUp(request);
            } catch (_) {}
          },
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static void _generateBlogContents() {
    _articles = [];
    _categories = {};
    _authors = {};
    _tags = {};

    _articles!.addAll(_blog?.posts ?? []);

    //Filter all articles per more recent to old one.
    _articles!.sort((a, b) => (b.date.compareTo(a.date)));

    //Categories
    _categories = articles.fold<List<String>>(
      [],
      (previousValue, element) => previousValue
        ..addAll(
          element.categories.where(
            (element) => false == previousValue.contains(element),
          ),
        ),
    ).toSet();

    //Tags
    _tags = articles.fold<List<String>>(
      [],
      (previousValue, element) => previousValue
        ..addAll(
          element.tags.where(
            (element) => false == previousValue.contains(element),
          ),
        ),
    ).toSet();

    //Authors
    _authors = articles.fold<List<Author>>(
      [],
      (previousValue, element) {
        if (previousValue.isEmpty && element.author != null) {
          previousValue.add(element.author!);
        } else {
          if (element.author != null &&
              !previousValue.contains(element.author)) {
            previousValue.add(element.author!);
          }
        }
        return previousValue;
      },
    ).toSet();
  }

  static Future<ResponseData<Blog>> getMedia(Uri apiMediaUri) async {
    ResponseData<Blog> response;

    try {
      var media =
          await http.get(apiMediaUri, headers: {"Accept": "Application/json"});

      if (media.contentLength != null) {
        LocalStorage.dataUse(int.parse(media.contentLength.toString()));
      }

      response = ResponseData<Blog>(
        message: "Media API fetched",
        data: Blog.fromJson(jsonDecode(media.body)),
      );
    } catch (e) {
      response = ResponseData<Blog>(
        message: "Error occured when fetching API.",
        exception: e.toString(),
      );
    }

    return response;
  }
}

enum StatusCode {
  none,
  ok,
  empty,
  fail,
}
