export 'article.dart';
export 'article_related.dart';
export 'author.dart';
export 'blog.dart';
export 'date_article.dart';
import 'package:quiver/core.dart';

import 'article.dart';

T? checkOptional<T>(Optional<T?>? optional, T? Function()? def) {
  // No value given, just take default value
  if (optional == null) return def?.call();

  // We have an input value
  if (optional.isPresent) return optional.value;

  // We have a null inside the optional
  return null;
}

bool searchArticleFunc(Article article, String? search) {
  return search == null ||
      search.isEmpty ||
      article.title.toLowerCase().contains(search.toLowerCase());
}
