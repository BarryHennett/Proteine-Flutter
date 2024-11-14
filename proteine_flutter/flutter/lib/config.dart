import 'package:flutter/foundation.dart';
class AppConfig {
  AppConfig._default();

  factory AppConfig() {
    return _current;
  }

  static AppConfig _current = AppConfig._default();

  static void setFlavor(AppConfig config) => _current = config;

  static bool get isRelease => kReleaseMode;

  bool get sendAnalytics => false;

  String get baseUrl => "";

}

class MVP extends AppConfig {
  MVP() : super._default();
}