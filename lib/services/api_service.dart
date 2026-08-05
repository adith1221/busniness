import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl =
      "http://10.0.2.2:8000/api/v1/auth"; // Use 10.0.2.2 for Android emulator
  static final _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      return data;
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> registerUser({
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    final accessToken = await _storage.read(key: 'access_token');

    if (accessToken == null) {
      throw Exception('Access token not found. Please verify OTP first.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/register/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'phone_number': phoneNumber,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
}
