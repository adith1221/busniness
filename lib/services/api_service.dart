import 'package:busniness/services/auth_service.dart';

class ApiService {
  static final AuthService _authService = AuthService();

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await _authService.sendOTP(phone: phoneNumber);

    if (response['statusCode'] == 200) {
      return (response['body'] as Map<String, dynamic>?) ?? {};
    }

    throw Exception(
      (response['body']?['message'] ?? 'Failed to send OTP').toString(),
    );
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    final response = await _authService.verifyOTP(phone: phoneNumber, otp: otp);

    if (response['statusCode'] == 200) {
      return (response['body'] as Map<String, dynamic>?) ?? {};
    }

    throw Exception(
      (response['body']?['message'] ?? 'Failed to verify OTP').toString(),
    );
  }

  static Future<Map<String, dynamic>> registerUser({
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final response = await _authService.register(
      phone: phoneNumber,
      email: email,
      password: password,
    );

    if (response['statusCode'] == 201 || response['statusCode'] == 200) {
      return (response['body'] as Map<String, dynamic>?) ?? {};
    }

    throw Exception(
      (response['body']?['message'] ?? 'Failed to register user').toString(),
    );
  }
}
