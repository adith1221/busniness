import 'dart:convert';

import 'package:busniness/models/product_model.dart';
import 'package:busniness/services/api_config.dart';
import 'package:busniness/services/token_service.dart';
import 'package:http/http.dart' as http;

class PicksService {
  final TokenService _tokenService = TokenService();

  Map<String, dynamic> _decodeBody(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }

  Future<Map<String, String>> _headers() async {
    final accessToken = await _tokenService.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Not authenticated');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<ProductModel>> fetchPicks() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.shopBaseUrl}/picks/'),
      headers: await _headers(),
    );

    final body = _decodeBody(response);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception((body['message'] ?? 'Failed to load picks').toString());
    }

    final data = body['data'] as List<dynamic>? ?? const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromPickMap)
        .toList();
  }

  Future<Set<String>> fetchPickKeys() async {
    try {
      final picks = await fetchPicks();
      return picks.map((item) => item.bookmarkKey).toSet();
    } catch (_) {
      return <String>{};
    }
  }

  Future<void> addPick(ProductModel product) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.shopBaseUrl}/picks/add/'),
      headers: await _headers(),
      body: jsonEncode({
        'product_key': product.bookmarkKey,
        'shopify_id': product.shopifyId,
        'title': product.title,
        'brand_name': product.brandName,
        'image': product.image,
        'price': product.price,
        'sale_price': product.priceAfetDiscount,
        'discount_percent': product.dicountpercent,
        'description': product.description,
      }),
    );

    final body = _decodeBody(response);
    if ((response.statusCode != 200 && response.statusCode != 201) ||
        body['success'] != true) {
      throw Exception((body['message'] ?? 'Failed to add to picks').toString());
    }
  }

  Future<void> removePick(ProductModel product) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.shopBaseUrl}/picks/remove/'),
      headers: await _headers(),
      body: jsonEncode({
        'product_key': product.bookmarkKey,
      }),
    );

    final body = _decodeBody(response);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(
        (body['message'] ?? 'Failed to remove from picks').toString(),
      );
    }
  }
}
