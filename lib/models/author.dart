import 'package:flutter/foundation.dart';



@immutable
class Author {

  const Author({
    required this.name,
    required this.avatar,
    required this.displayName,
    required this.gravatar,
    required this.email,
    required this.site,
    required this.twitter,
    required this.social,
    required this.instagram,
    required this.bio,
  });

  final String name;
  final String avatar;
  final String displayName;
  final String gravatar;
  final String? email;
  final String? site;
  final String? twitter;
  final String social;
  final String? instagram;
  final String bio;

  factory Author.fromJson(Map<String,dynamic> json) => Author(
    name: json['name'].toString(),
    avatar: json['avatar'].toString(),
    displayName: json['display_name'].toString(),
    gravatar: json['gravatar'].toString(),
    email: json['email'].toString(),
    site: json['site'].toString(),
    twitter: json['twitter'].toString(),
    social: json['social'].toString(),
    instagram: json['instagram'].toString(),
    bio: json['bio'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'avatar': avatar,
    'display_name': displayName,
    'gravatar': gravatar,
    'email': email,
    'site': site,
    'twitter': twitter,
    'social': social,
    'instagram': instagram,
    'bio': bio
  };

  Author clone() => Author(
    name: name,
    avatar: avatar,
    displayName: displayName,
    gravatar: gravatar,
    email: email,
    site: site,
    twitter: twitter,
    social: social,
    instagram: instagram,
    bio: bio
  );


  Author copyWith({
    String? name,
    String? avatar,
    String? displayName,
    String? gravatar,
    String? email,
    String? site,
    String? twitter,
    String? social,
    String? instagram,
    String? bio
  }) => Author(
    name: name ?? this.name,
    avatar: avatar ?? this.avatar,
    displayName: displayName ?? this.displayName,
    gravatar: gravatar ?? this.gravatar,
    email: email ?? this.email,
    site: site ?? this.site,
    twitter: twitter ?? this.twitter,
    social: social ?? this.social,
    instagram: instagram ?? this.instagram,
    bio: bio ?? this.bio,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is Author && name == other.name && avatar == other.avatar && displayName == other.displayName && gravatar == other.gravatar && email == other.email && site == other.site && twitter == other.twitter && social == other.social && instagram == other.instagram && bio == other.bio;

  @override
  int get hashCode => name.hashCode ^ avatar.hashCode ^ displayName.hashCode ^ gravatar.hashCode ^ email.hashCode ^ site.hashCode ^ twitter.hashCode ^ social.hashCode ^ instagram.hashCode ^ bio.hashCode;
}
