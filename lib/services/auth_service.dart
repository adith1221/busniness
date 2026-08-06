import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busniness/services/api_config.dart';
import 'package:busniness/services/token_service.dart';

class AuthService {
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> sendOTP({
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.authBaseUrl}/send-otp/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone_number": phone,
        }),
      );

      return {
        "statusCode": response.statusCode,
        "body": jsonDecode(response.body),
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {
          "message": e.toString(),
        }
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.authBaseUrl}/register/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone_number": phone,
          "email": email,
          "password": password,
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = body["access_token"] as String?;
      final refreshToken = body["refresh_token"] as String?;
      if (accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        await _tokenService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      return {
        "statusCode": response.statusCode,
        "body": body,
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {
          "message": e.toString(),
        }
      };
    }
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.authBaseUrl}/verify-otp/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone_number": phone,
          "otp": otp,
        }),
      );

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = body["access_token"] as String?;
      final refreshToken = body["refresh_token"] as String?;
      if (response.statusCode == 200 &&
          accessToken != null &&
          accessToken.isNotEmpty &&
          refreshToken != null &&
          refreshToken.isNotEmpty) {
        await _tokenService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      return {
        "statusCode": response.statusCode,
        "body": body,
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {
          "message": e.toString(),
        }
      };
    }
  }
}
