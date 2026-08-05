class ApiConfig {
  static const String authBaseUrl = 'http://10.24.54.72:8000/api/v1/auth';
  static const String registerPath = '/register/';

  static String get registerUrl => '$authBaseUrl$registerPath';
}
