import 'dart:convert';

class ResponseData<T> {
  T? data;

  dynamic exception;

  bool success;

  String? message = '';

  static T? parse<T>(
    T Function(dynamic json) factory,
    dynamic data, [
    bool tolerateParseError = false,
  ]) {
    try {
      return factory(data);
    } catch (e) {
      return (tolerateParseError) ? null : throw e;
    }
  }

  factory ResponseData.fromJson(
    String body,
    T Function(dynamic json) factory, {
    String? messageError,
    String? messageSuccess,
    bool tolerateParseError = false,
  }) {
    final Map<String, dynamic> parsed = json.decode(body);
    return ResponseData(
      success: parsed['success'],
      exception: parsed['exception'],
      message: (parsed['success'] ?? false)
          ? (messageSuccess ?? parsed['message'])
          : (messageError ?? parsed['message']),
      data: (parsed['success'] ?? false)
          ? parse<T>(factory, parsed['data'], tolerateParseError)
          : null,
    );
  }

  bool get result => data != null;

  factory ResponseData.fail(String message, [dynamic exception]) {
    return ResponseData<T>(
      exception: exception,
      message: message,
      data: null,
      success: false,
    );
  }

  ResponseData({
    this.exception,
    this.message,
    this.data,
    this.success = false,
  });
}

class ResponseDataList<T> {
  List<T>? list;

  final String? message;

  final bool success;

  bool get result => list != null;

  dynamic exception;

  ResponseDataList({
    this.exception,
    this.message,
    this.list,
    this.success = false,
  });

  factory ResponseDataList.fail(String message, [dynamic exception]) {
    return ResponseDataList<T>(
      exception: exception,
      message: message,
      list: null,
      success: false,
    );
  }

  factory ResponseDataList.fromJson(
    String body,
    T Function(Map<String, dynamic> json) factory, {
    String? messageError,
    String? messageSuccess,
  }) {
    final Map<String, dynamic> parsed = json.decode(body);
    return ResponseDataList(
      exception: parsed['exception'],
      success: parsed['success'],
      message: (parsed['success'] ?? false)
          ? (messageSuccess ?? parsed['message'])
          : (messageError ?? parsed['message']),
      list: parsed['data']
          .cast<Map<String, dynamic>>()
          .map<T>((m) => factory(m))
          .toList(),
    );
  }
}
