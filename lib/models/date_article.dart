import 'package:flutter/foundation.dart';



@immutable
class DateArticle {

  const DateArticle({
    required this.day,
    required this.month,
    required this.year,
    required this.complete,
  });

  final String day;
  final String month;
  final String year;
  final String complete;

  factory DateArticle.fromJson(Map<String,dynamic> json) => DateArticle(
    day: json['day'].toString(),
    month: json['month'].toString(),
    year: json['year'].toString(),
    complete: json['complete'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'day': day,
    'month': month,
    'year': year,
    'complete': complete
  };

  DateArticle clone() => DateArticle(
    day: day,
    month: month,
    year: year,
    complete: complete
  );


  DateArticle copyWith({
    String? day,
    String? month,
    String? year,
    String? complete
  }) => DateArticle(
    day: day ?? this.day,
    month: month ?? this.month,
    year: year ?? this.year,
    complete: complete ?? this.complete,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is DateArticle && day == other.day && month == other.month && year == other.year && complete == other.complete;

  @override
  int get hashCode => day.hashCode ^ month.hashCode ^ year.hashCode ^ complete.hashCode;
}
