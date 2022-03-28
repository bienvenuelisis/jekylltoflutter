import 'package:flutter/foundation.dart';
import 'index.dart';

import 'article.dart';

@immutable
class Blog {

  const Blog({
    required this.homepage,
    required this.version,
    required this.name,
    required this.description,
    required this.logo,
    required this.lastUpdate,
    required this.expired,
    required this.favicon,
    required this.url,
    required this.disqus,
    required this.email,
    required this.paginate,
    required this.posts,
  });

  final String homepage;
  final String version;
  final String name;
  final String description;
  final String logo;
  final DateTime lastUpdate;
  final bool expired;
  final String favicon;
  final String url;
  final String disqus;
  final String email;
  final String paginate;
  final List<Article> posts;

  factory Blog.fromJson(Map<String,dynamic> json) => Blog(
    homepage: json['homepage'].toString(),
    version: json['version'].toString(),
    name: json['name'].toString(),
    description: json['description'].toString(),
    logo: json['logo'].toString(),
    lastUpdate: DateTime.parse(json['last_update'] as String),
    expired: json['expired'] as bool,
    favicon: json['favicon'].toString(),
    url: json['url'].toString(),
    disqus: json['disqus'].toString(),
    email: json['email'].toString(),
    paginate: json['paginate'].toString(),
    posts: (json['posts'] as List? ?? []).map((e) => Article.fromJson(e as Map<String, dynamic>)).toList()
  );
  
  Map<String, dynamic> toJson() => {
    'homepage': homepage,
    'version': version,
    'name': name,
    'description': description,
    'logo': logo,
    'last_update': lastUpdate.toIso8601String(),
    'expired': expired,
    'favicon': favicon,
    'url': url,
    'disqus': disqus,
    'email': email,
    'paginate': paginate,
    'posts': posts.map((e) => e.toJson()).toList()
  };

  Blog clone() => Blog(
    homepage: homepage,
    version: version,
    name: name,
    description: description,
    logo: logo,
    lastUpdate: lastUpdate,
    expired: expired,
    favicon: favicon,
    url: url,
    disqus: disqus,
    email: email,
    paginate: paginate,
    posts: posts.map((e) => e.clone()).toList()
  );


  Blog copyWith({
    String? homepage,
    String? version,
    String? name,
    String? description,
    String? logo,
    DateTime? lastUpdate,
    bool? expired,
    String? favicon,
    String? url,
    String? disqus,
    String? email,
    String? paginate,
    List<Article>? posts
  }) => Blog(
    homepage: homepage ?? this.homepage,
    version: version ?? this.version,
    name: name ?? this.name,
    description: description ?? this.description,
    logo: logo ?? this.logo,
    lastUpdate: lastUpdate ?? this.lastUpdate,
    expired: expired ?? this.expired,
    favicon: favicon ?? this.favicon,
    url: url ?? this.url,
    disqus: disqus ?? this.disqus,
    email: email ?? this.email,
    paginate: paginate ?? this.paginate,
    posts: posts ?? this.posts,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Blog && homepage == other.homepage && version == other.version && name == other.name && description == other.description && logo == other.logo && lastUpdate == other.lastUpdate && expired == other.expired && favicon == other.favicon && url == other.url && disqus == other.disqus && email == other.email && paginate == other.paginate && posts == other.posts;

  @override
  int get hashCode => homepage.hashCode ^ version.hashCode ^ name.hashCode ^ description.hashCode ^ logo.hashCode ^ lastUpdate.hashCode ^ expired.hashCode ^ favicon.hashCode ^ url.hashCode ^ disqus.hashCode ^ email.hashCode ^ paginate.hashCode ^ posts.hashCode;
}
