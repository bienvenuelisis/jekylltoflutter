import 'package:flutter/foundation.dart';
import 'index.dart';

import 'author.dart';

@immutable
class ArticleRelated {

  const ArticleRelated({
    required this.id,
    required this.slug,
    required this.url,
    required this.title,
    required this.image,
    required this.author,
    required this.readTime,
    required this.dateFr,
    required this.dateEn,
    required this.categoryMain,
    required this.tags,
    required this.type,
  });

  final String id;
  final String slug;
  final String url;
  final String title;
  final String image;
  final Author? author;
  final String readTime;
  final String dateFr;
  final String dateEn;
  final String categoryMain;
  final List<String> tags;
  ArticleRelatedTypeEnum get articleRelatedTypeEnum => _articleRelatedTypeEnumValues.map[type]!;
  final String type;

  factory ArticleRelated.fromJson(Map<String,dynamic> json) => ArticleRelated(
    id: json['id'].toString(),
    slug: json['slug'].toString(),
    url: json['url'].toString(),
    title: json['title'].toString(),
    image: json['image'].toString(),
    author: Author.fromJson(json['author'] as Map<String, dynamic>),
    readTime: json['read_time'].toString(),
    dateFr: json['date_fr'].toString(),
    dateEn: json['date_en'].toString(),
    categoryMain: json['category_main'].toString(),
    tags: (json['tags'] as List? ?? []).map((e) => e as String).toList(),
    type: json['type'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'url': url,
    'title': title,
    'image': image,
    'author': author?.toJson(),
    'read_time': readTime,
    'date_fr': dateFr,
    'date_en': dateEn,
    'category_main': categoryMain,
    'tags': tags.map((e) => e.toString()).toList(),
    'type': type
  };

  ArticleRelated clone() => ArticleRelated(
    id: id,
    slug: slug,
    url: url,
    title: title,
    image: image,
    author: author?.clone(),
    readTime: readTime,
    dateFr: dateFr,
    dateEn: dateEn,
    categoryMain: categoryMain,
    tags: tags.toList(),
    type: type
  );


  ArticleRelated copyWith({
    String? id,
    String? slug,
    String? url,
    String? title,
    String? image,
    Author? author,
    String? readTime,
    String? dateFr,
    String? dateEn,
    String? categoryMain,
    List<String>? tags,
    String? type
  }) => ArticleRelated(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    url: url ?? this.url,
    title: title ?? this.title,
    image: image ?? this.image,
    author: author ?? this.author,
    readTime: readTime ?? this.readTime,
    dateFr: dateFr ?? this.dateFr,
    dateEn: dateEn ?? this.dateEn,
    categoryMain: categoryMain ?? this.categoryMain,
    tags: tags ?? this.tags,
    type: type ?? this.type,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ArticleRelated && id == other.id && slug == other.slug && url == other.url && title == other.title && image == other.image && author == other.author && readTime == other.readTime && dateFr == other.dateFr && dateEn == other.dateEn && categoryMain == other.categoryMain && tags == other.tags && type == other.type;

  @override
  int get hashCode => id.hashCode ^ slug.hashCode ^ url.hashCode ^ title.hashCode ^ image.hashCode ^ author.hashCode ^ readTime.hashCode ^ dateFr.hashCode ^ dateEn.hashCode ^ categoryMain.hashCode ^ tags.hashCode ^ type.hashCode;
}

enum ArticleRelatedTypeEnum { post }

extension ArticleRelatedTypeEnumEx on ArticleRelatedTypeEnum{
  String? get value => _articleRelatedTypeEnumValues.reverse[this];
}

final _articleRelatedTypeEnumValues = _ArticleRelatedTypeEnumConverter({
  'post': ArticleRelatedTypeEnum.post,
});


class _ArticleRelatedTypeEnumConverter<String, O> {
  final Map<String, O> map;
  Map<O, String>? reverseMap;

  _ArticleRelatedTypeEnumConverter(this.map);

  Map<O, String> get reverse => reverseMap ??= map.map((k, v) => MapEntry(v, k));
}

