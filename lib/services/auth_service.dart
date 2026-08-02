import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.0.2.2:8000/api/v1/auth";

  Future<bool> register({
    required String phone,
    required String email,
    required String password,
  }) async {
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

    print(response.body);

    return response.statusCode == 201;
  }
}
