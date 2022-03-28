import 'package:jekylltoflutter/services/jekyll_blog.dart';
import 'package:jekylltoflutter/models/index.dart';

import '../models/params.dart';
import 'local_storage.dart';

class Feeds {
  static const String categoriesKey = 'categories-articles-localStorage-key';

  static const String tagsKey = 'tags-articles-localStorage-key';

  static int actualPage = 1;

  static const int actualPageDf = 1;

  static const int perPageDf = 5;

  static int perPage = 5;

  static List<String> categoriesNames() {
    List<String>? names =
        LocalStorage.localStorage.getStringList(categoriesKey);
    if (names == null || names.isEmpty) {
      names = JekyllBlog.categories.toList();
      LocalStorage.localStorage.setStringList(categoriesKey, names.toList());
    }

    return names.toList();
  }

  static List<String> tagsNames() {
    List<String>? names = LocalStorage.localStorage.getStringList(tagsKey);
    if (names == null || names.isEmpty) {
      names = JekyllBlog.tags.toList();
      LocalStorage.localStorage.setStringList(tagsKey, names);
    }

    return names;
  }

  static ArticlesGetRequestParams get postsParamsDefault {
    return ArticlesGetRequestParams(page: actualPageDf, perPage: perPageDf);
  }

  static ArticlesGetRequestParams get postsParamsDefaultMain {
    return ArticlesGetRequestParams(
        page: actualPageDf, perPage: perPageDf, sticky: true);
    //.setMedia(MediaEnum.NOIRMEILLEUR);
  }

  static ArticlesGetRequestParams get postsParamsActual {
    return ArticlesGetRequestParams(page: actualPage, perPage: perPage);
  }

  static ArticlesGetRequestParams postsParamsByCategoryFirsts(String category) {
    return ArticlesGetRequestParams(page: 1, perPage: 10)
        .setMainCategory(category);
  }

  static List<Article> featured() {
    return JekyllBlog.articles.where((a) => a.featured).toList();
  }

  static List<Article> firstPosts() {
    return postsParamsDefault.fetchPostsOf;
  }

  static List<Article> firstPostsByCategories(String category) {
    return postsParamsByCategoryFirsts(category).fetchPostsOf;
  }

  static List<Article> mostRecents(int count) {
    return ArticlesGetRequestParams(page: 1, perPage: count).fetchPostsOf;
  }

  static List<Article> firstPostsMain() {
    return postsParamsDefaultMain.fetchPostsOf;
  }

  static List<Article> nextPosts() {
    actualPage++;
    return postsParamsActual.fetchPostsOf;
  }

  static Set<String> mainCategories() {
    return JekyllBlog.articles.map((a) => a.categoryMain.toLowerCase()).toSet();
  }
}
