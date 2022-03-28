import 'package:jekylltoflutter/models/index.dart';

import '../services/jekyll_blog.dart';

enum ArticlesSortOrder { asc, desc }

enum ArticlesOrderBy { author, date, modified, relevance, title }

class ArticlesGetRequestParams {
  ArticlesGetRequestParams({
    this.after,
    this.author,
    this.authorsExclude = const [],
    this.before,
    this.offset,
    this.order = ArticlesSortOrder.desc,
    this.orderby = ArticlesOrderBy.date,
    this.page = 1,
    this.perPage = 10,
    this.search,
    this.sticky,
    this.featured,
    this.premium,
    this.excludes = const [],
    this.categories = const [],
    this.category,
    this.categoriesExcludes = const [],
    this.tags = const [],
    this.tagsExclude = const [],
  });

  /// Limit response to posts published after a given ISO8601 compliant date.
  DateTime? after;

  /// Limit result set to posts assigned to specific authors.
  Author? author;

  /// Ensure result set excludes posts assigned to specific authors.
  List<Author> authorsExclude;

  /// Limit response to posts published before a given ISO8601 compliant date.
  DateTime? before;

  ///Limit result set based on relationship between multiple taxonomies. One of: AND, OR
  ///Limit result set to all items that have the specified term assigned in the categories taxonomy.
  List<String> categories;

  ///Limit result set to all items except those that have the specified term assigned in the categories taxonomy.
  List<String> categoriesExcludes;

  String? category;

  /// Ensure result set excludes specific IDs.
  List<Article> excludes;

  bool? featured;

  /// Offset the result set by a specific number of items.
  int? offset;

  /// Order sort attribute ascending or descending.
  /// Default: desc
  ArticlesSortOrder order;

  ///Sort collection by object attribute.
  /// Default: date
  ArticlesOrderBy orderby;

  int? page;

  /// Maximum number of items to be returned in result set. Default 10.
  int? perPage;

  bool? premium;

  /// Limit results to those matching a string.
  String? search;

  ///Limit result set to items that are sticky.
  bool? sticky;

  ///Limit result set to all items that have the specified term assigned in the tags taxonomy.
  List<String> tags;

  ///Limit result set to all items except those that have the specified term assigned in the tags taxonomy.
  List<String> tagsExclude;

  ArticlesGetRequestParams setTags(List<String> tags) {
    this.tags = tags;
    return this;
  }

  ArticlesGetRequestParams setExcludedTags(List<String> tagsExclude) {
    this.tagsExclude = tagsExclude;
    return this;
  }

  ArticlesGetRequestParams setCategories(List<String> categories) {
    this.categories = categories;
    return this;
  }

  ArticlesGetRequestParams setMainCategory(String category) {
    this.category = category;
    return this;
  }

  bool corresponds(Article article, [String featuredTag = ""]) {
    return (searchArticleFunc(article, search)) &&
        (author == null || article.author == author) &&
        (excludes.isEmpty || !excludes.contains(article)) &&
        (category == null || article.categoryMain.toLowerCase() == category) &&
        (categories.isEmpty || article.categories == categories) &&
        (tags.isEmpty || article.tags == tags) &&
        (featured == null || article.featured == featured) &&
        (sticky == null || (article.tags.contains(featuredTag))) &&
        (authorsExclude.isEmpty || !authorsExclude.contains(article.author));
  }

  List<Article> get fetchPostsOf {
    List<Article> results = JekyllBlog.articles
        .where((a) => corresponds(a, JekyllBlog.featuredTag))
        .toList();

    int length = results.length;

    if (page == null || perPage == null) {
      if (offset == null) {
        return results;
      } else {
        return offset! >= length ? [] : results.sublist(offset!);
      }
    } else {
      int start = perPage! * (page! - 1);
      if (start >= length) {
        return [];
      } else {
        int end = start + perPage!;
        return results.sublist(start, end > length ? length : end);
      }
    }
  }
}
