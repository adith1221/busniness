import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _scheme =
      String.fromEnvironment('API_SCHEME', defaultValue: 'http');
  static const String _hostOverride =
      String.fromEnvironment('API_HOST', defaultValue: '');
  static const String _port =
      String.fromEnvironment('API_PORT', defaultValue: '8000');
  static const String _basePath = '/api/v1';

  static String get host {
    if (_hostOverride.isNotEmpty) {
      return _hostOverride;
    }

    if (kIsWeb) {
      return '127.0.0.1';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return '10.0.2.2';
      default:
        return '127.0.0.1';
    }
  }

  static String get baseUrl => '$_scheme://$host:$_port$_basePath';
  static String get authBaseUrl => '$baseUrl/auth';
  static String get profileBaseUrl => '$baseUrl/profile';
  static String get dashboardBaseUrl => '$baseUrl/dashboard';
  static String get shopBaseUrl => '$baseUrl/shop';
}
