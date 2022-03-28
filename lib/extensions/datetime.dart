import 'package:intl/intl.dart';

extension DateTimeNullableUtils on DateTime? {
  String get str {
    return this == null ? "" : DateFormat.yMMMEd("fr_FR").format(this!);
  }
}

extension DateTimeUtils on DateTime {
  String get dateString {
    return "$day/$month/$year";
  }

  String get timeString {
    return "${hour}h$minute";
  }

  String get dateTimeString {
    return "$day/$month/$year à ${hour}h$minute";
  }

  DateFormat get humanReadableDateFormat => DateFormat(
        "EEEE d MMM y à HH:mm.",
        "fr",
      );

  String get str {
    return DateFormat.yMMMEd("fr_FR").format(this);
  }

  String get format {
    return toIso8601String();
  }

  String get humanReadableDate {
    return humanReadableDateFormat.format(this);
  }

  DateFormat get standardFormat => DateFormat("yyyy-MM-dd HH:mm");

  String get toStr {
    return standardFormat.format(this);
  }
}

extension StringToDate on String {
  DateFormat get standardFormat => DateFormat("yyyy-MM-dd HH:mm");

  DateTime get toDateTime => standardFormat.parse(this);

  DateTime get parsed => DateTime.parse(this);

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringToDateNullable on String? {
  DateTime? get parsed => this == null ? null : DateTime.parse(this!);
}
