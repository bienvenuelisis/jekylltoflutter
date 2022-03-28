import 'dart:collection';

import 'package:jekylltoflutter/services/jekyll_blog.dart';
import 'package:jekylltoflutter/models/index.dart';
import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  int get count => _favoritesPosts.length;

  bool _error = false;

  bool get error => _error;

  bool _isCompleted = false;

  bool get complete => _isCompleted;

  bool _loading = true;

  bool get loading => _loading;

  List<Article> _favoritesPosts = [];

  FavoriteProvider() {
    refreshContents();
  }

  UnmodifiableListView<Article> get favoritesPosts =>
      UnmodifiableListView(_favoritesPosts);

  void _getFavoritesPosts() async {
    try {
      JekyllBlog.favoritesPosts
          .forEach((article) => {registerNewFavoriteArticle(article)});
      _favoritesPosts = _favoritesPosts.reversed.toList();
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

  void registerNewFavoriteArticle(Article article) {
    if (_loading) {
      _loading = false;
    }

    _favoritesPosts.add(article);
    notifyListeners();
  }

  Future<void> refreshContents() async {
    _error = false;
    _loading = true;
    _isCompleted = false;
    _favoritesPosts = [];

    notifyListeners();
    _getFavoritesPosts();
  }
}
