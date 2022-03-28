import 'package:flutter/foundation.dart';
import 'index.dart';

@immutable
class Article {
  const Article({
    required this.id,
    required this.slug,
    required this.url,
    required this.title,
    required this.date,
    required this.image,
    required this.featured,
    required this.premium,
    required this.sticky,
    required this.author,
    required this.readTime,
    required this.dateIso,
    required this.dateFr,
    required this.dateEn,
    required this.categoryMain,
    required this.categories,
    required this.tags,
    required this.next,
    required this.previous,
    required this.comments,
    required this.summary,
    required this.content,
  });

  final String id;
  final String slug;
  final String url;
  final String title;
  final String date;
  final String? image;
  final bool featured;
  final bool premium;
  final bool sticky;
  final Author? author;
  final String readTime;
  final DateTime dateIso;
  final DateArticle dateFr;
  final DateArticle dateEn;
  final String categoryMain;
  final List<String> categories;
  final List<String> tags;
  final ArticleRelated? next;
  final ArticleRelated? previous;
  final String comments;
  final String summary;
  final String content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
      id: json['id'].toString(),
      slug: json['slug'].toString(),
      url: json['url'].toString(),
      title: json['title'].toString(),
      date: json['date'].toString(),
      image: json['image'].toString(),
      featured: json['featured'] as bool,
      premium: json['premium'] as bool,
      sticky: (json['sticky'] ?? false) as bool,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      readTime: json['read_time'].toString(),
      dateIso: DateTime.parse(json['date_iso'] as String),
      dateFr: DateArticle.fromJson(json['date_fr'] as Map<String, dynamic>),
      dateEn: DateArticle.fromJson(json['date_en'] as Map<String, dynamic>),
      categoryMain: json['category_main'].toString(),
      categories:
          (json['categories'] as List? ?? []).map((e) => e as String).toList(),
      tags: (json['tags'] as List? ?? []).map((e) => e as String).toList(),
      next: (json['next'] == null ||
              (json['next'] as Map<String, dynamic>).isEmpty)
          ? null
          : ArticleRelated.fromJson(json['next'] as Map<String, dynamic>),
      previous: (json['previous'] == null ||
              (json['previous'] as Map<String, dynamic>).isEmpty)
          ? null
          : ArticleRelated.fromJson(json['previous'] as Map<String, dynamic>),
      comments: json['comments'].toString(),
      summary: json['summary'].toString(),
      content: json['content'].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'url': url,
        'title': title,
        'date': date,
        'image': image,
        'featured': featured,
        'premium': premium,
        'sticky': sticky,
        'author': author?.toJson(),
        'read_time': readTime,
        'date_iso': dateIso.toIso8601String(),
        'date_fr': dateFr.toJson(),
        'date_en': dateEn.toJson(),
        'category_main': categoryMain,
        'categories': categories.map((e) => e.toString()).toList(),
        'tags': tags.map((e) => e.toString()).toList(),
        'next': next?.toJson(),
        'previous': previous?.toJson(),
        'comments': comments,
        'summary': summary,
        'content': content
      };

  Article clone() => Article(
      id: id,
      slug: slug,
      url: url,
      title: title,
      date: date,
      image: image,
      featured: featured,
      premium: premium,
      sticky: sticky,
      author: author?.clone(),
      readTime: readTime,
      dateIso: dateIso,
      dateFr: dateFr.clone(),
      dateEn: dateEn.clone(),
      categoryMain: categoryMain,
      categories: categories.toList(),
      tags: tags.toList(),
      next: next?.clone(),
      previous: previous?.clone(),
      comments: comments,
      summary: summary,
      content: content);

  Article copyWith(
          {String? id,
          String? slug,
          String? url,
          String? title,
          String? date,
          String? image,
          bool? featured,
          bool? premium,
          bool? sticky,
          Author? author,
          String? readTime,
          DateTime? dateIso,
          DateArticle? dateFr,
          DateArticle? dateEn,
          String? categoryMain,
          List<String>? categories,
          List<String>? tags,
          ArticleRelated? next,
          ArticleRelated? previous,
          String? comments,
          String? summary,
          String? content}) =>
      Article(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        url: url ?? this.url,
        title: title ?? this.title,
        date: date ?? this.date,
        image: image ?? this.image,
        featured: featured ?? this.featured,
        premium: premium ?? this.premium,
        sticky: sticky ?? this.sticky,
        author: author ?? this.author,
        readTime: readTime ?? this.readTime,
        dateIso: dateIso ?? this.dateIso,
        dateFr: dateFr ?? this.dateFr,
        dateEn: dateEn ?? this.dateEn,
        categoryMain: categoryMain ?? this.categoryMain,
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
        next: next ?? this.next,
        previous: previous ?? this.previous,
        comments: comments ?? this.comments,
        summary: summary ?? this.summary,
        content: content ?? this.content,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          id == other.id &&
          slug == other.slug &&
          url == other.url &&
          title == other.title &&
          date == other.date &&
          image == other.image &&
          featured == other.featured &&
          premium == other.premium &&
          sticky == other.sticky &&
          author == other.author &&
          readTime == other.readTime &&
          dateIso == other.dateIso &&
          dateFr == other.dateFr &&
          dateEn == other.dateEn &&
          categoryMain == other.categoryMain &&
          categories == other.categories &&
          tags == other.tags &&
          next == other.next &&
          previous == other.previous &&
          comments == other.comments &&
          summary == other.summary &&
          content == other.content;

  @override
  int get hashCode =>
      id.hashCode ^
      slug.hashCode ^
      url.hashCode ^
      title.hashCode ^
      date.hashCode ^
      image.hashCode ^
      featured.hashCode ^
      premium.hashCode ^
      sticky.hashCode ^
      author.hashCode ^
      readTime.hashCode ^
      dateIso.hashCode ^
      dateFr.hashCode ^
      dateEn.hashCode ^
      categoryMain.hashCode ^
      categories.hashCode ^
      tags.hashCode ^
      next.hashCode ^
      previous.hashCode ^
      comments.hashCode ^
      summary.hashCode ^
      content.hashCode;
}
