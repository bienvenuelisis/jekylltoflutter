import "package:flutter/services.dart" as s;
import "package:yaml/yaml.dart";

class JekyllConfig {
  final YamlMap yaml;

  static JekyllConfig? _instance;

  static Future<JekyllConfig> get instance async {
    _instance ??= JekyllConfig(
      loadYaml(await s.rootBundle.loadString("config/site.yaml")),
    );

    return _instance!;
  }

  JekyllConfig(this.yaml);

  dynamic get(String key) {
    return yaml[key];
  }

  dynamic getOrDefault(String key, dynamic defaultValue) {
    return yaml[key] ?? defaultValue;
  }

  dynamic getOrElse(String key, dynamic Function() defaultValue) {
    return yaml[key] ?? defaultValue();
  }

  bool has(String key) {
    return yaml.containsKey(key);
  }

  bool getBool(String key) {
    return yaml[key] as bool;
  }

  int getInt(String key) {
    return yaml[key] as int;
  }

  double getDouble(String key) {
    return yaml[key] as double;
  }

  String getString(String key) {
    return yaml[key] as String;
  }

  List<dynamic> getList(String key) {
    return yaml[key] as List<dynamic>;
  }

  Map<String, dynamic> getMap(String key) {
    return yaml[key] as Map<String, dynamic>;
  }
}
