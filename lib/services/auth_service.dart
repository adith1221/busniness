import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Android Emulator
  static const String baseUrl = "http://10.0.2.2:8000/api/v1/auth";

  // iOS Simulator
  // static const String baseUrl = "http://127.0.0.1:8000/api/v1/auth";

  Future<Map<String, dynamic>> sendOTP({
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/send-otp/"),
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
        Uri.parse("$baseUrl/register/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone_number": phone,
          "email": email,
          "password": password,
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

  Future<Map<String, dynamic>> verifyOTP({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verify-otp/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "phone_number": phone,
          "otp": otp,
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
}
