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

  String get baseUrl => "https://api-ipowzzbk4q-uc.a.run.app";

}

class MVP extends AppConfig {
  MVP() : super._default();
}