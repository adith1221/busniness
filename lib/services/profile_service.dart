import 'dart:convert';

import 'package:busniness/services/api_config.dart';
import 'package:busniness/services/token_service.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  final TokenService _tokenService = TokenService();

  Future<Map<String, dynamic>> fetchProfile() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.profileBaseUrl}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && body['success'] == true) {
      return (body['data'] as Map<String, dynamic>?) ?? {};
    }

    final message = body['message']?.toString() ?? 'Failed to fetch profile';
    throw Exception(message);
  }
}
