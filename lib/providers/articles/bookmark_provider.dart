import 'dart:collection';

import 'package:jekylltoflutter/services/jekyll_blog.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:flutter/foundation.dart';

class BookmarkProvider extends ChangeNotifier {
  int get count => _bookmarksPosts.length;

  bool _error = false;

  bool get error => _error;

  bool _isCompleted = false;

  bool get complete => _isCompleted;

  bool _loading = true;

  bool get loading => _loading;

  List<Article> _bookmarksPosts = [];

  BookmarkProvider() {
    refreshContents();
  }

  UnmodifiableListView<Article> get bookmarksPosts =>
      UnmodifiableListView(_bookmarksPosts);

  void _getBookmarksPosts() async {
    try {
      for (var article in JekyllBlog.bookmarksPosts) {
        registerNewBookmarkArticle(article);
      }
      _bookmarksPosts = _bookmarksPosts.reversed.toList();
    } catch (e) {
      debugPrint(e.toString());

      if (count == 0) {
        _error = true;
        notifyListeners();
      }
    }

    _loading = false;
    _isCompleted = true;
    notifyListeners();
  }

  void registerNewBookmarkArticle(Article article) {
    if (_loading) {
      _loading = false;
    }

    _bookmarksPosts.add(article);
    notifyListeners();
  }

  Future<void> refreshContents() async {
    _error = false;
    _loading = true;
    _isCompleted = false;
    _bookmarksPosts = [];

    notifyListeners();
    _getBookmarksPosts();
  }
}
