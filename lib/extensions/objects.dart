import 'package:flutter/foundation.dart';

extension Log on Object {
  void log() {
    debugPrint(toString());
  }
}

extension BoolSafe on bool? {
  bool get safe => this ?? false;
}

extension IntUtils on int {
  Duration get milliseconds => Duration(milliseconds: this);

  Duration get seconds => Duration(seconds: this);

  Duration get minutes => Duration(seconds: this);

  bool toBool() => this != 0;
}

extension IntUtilsNullable on int? {
  bool toBool([bool defaultValue = false]) =>
      this == null ? defaultValue : this != 0;
}

Future<void> waitDuration(Duration duration) async {
  await Future.delayed(duration);
}

extension DurationsUtils on Duration {
  Future<void> get wait => waitDuration(this);
}

extension DynamicUtils on dynamic {
  bool toBool([bool defaultValue = false]) =>
      (this is int) ? (this as int).toBool() : (this ?? false);
}

bool toBool(dynamic value, [bool defaultValue = false]) =>
    (value is int) ? (value).toBool() : (value ?? defaultValue);

extension StringUtils on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}

extension ListUtils on List? {
  bool equalsValues(List? others) {
    if (others == null || this == null) {
      return (others == null && this == null) ||
          ((others ?? []).isEmpty &&
              (this ?? []).isEmpty &&
              ((others ?? []).length == (others ?? []).length));
    }

    if (others.length != (this!).length) return false;

    for (int i = 0; i < (this!).length; i++) {
      if (this![i] != others[i]) return false;
    }
    return true;
  }
}
