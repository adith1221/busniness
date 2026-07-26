import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:busniness/models/product_model.dart';

class ShopifyCollection {
  ShopifyCollection({
    required this.handle,
    required this.title,
    this.imageUrl = '',
  });

  final String handle;
  final String title;
  final String imageUrl;
}

class ShopifyService {
  ShopifyService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<ShopifyCollection>> fetchCollections() async {
    const storeDomain = 'mimsico.myshopify.com';
    const accessToken = '92c151ad07a7a610b0aeb4003d375f59';

    if (accessToken.isEmpty) {
      return [];
    }

    final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': accessToken,
      },
      body: jsonEncode({
        'query': '''
          query getCollections {
            collections(first: 10, sortKey: TITLE) {
              edges {
                node {
                  id
                  title
                  handle
                  image {
                    url
                    altText
                  }
                }
              }
            }
          }
        ''',
      }),
    );

    if (response.statusCode != 200) {
      return [];
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final edges =
          body['data']?['collections']?['edges'] as List<dynamic>? ?? const [];

      return edges
          .map((edge) {
            final node = (edge as Map<String, dynamic>)['node']
                    as Map<String, dynamic>? ??
                <String, dynamic>{};
            return ShopifyCollection(
              handle: (node['handle'] as String?) ?? '',
              title: (node['title'] as String?) ?? 'Collection',
              imageUrl: (node['image']?['url'] as String?) ?? '',
            );
          })
          .where((item) => item.handle.isNotEmpty)
          .toList();
    } catch (error, stackTrace) {
      debugPrint('Shopify collections parsing error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  Future<List<ProductModel>> fetchCollectionProducts(String handle) async {
    const storeDomain = 'mimsico.myshopify.com';
    const accessToken = '92c151ad07a7a610b0aeb4003d375f59';

    if (accessToken.isEmpty || handle.isEmpty) {
      return [];
    }

    final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': accessToken,
      },
      body: jsonEncode({
        'query': '''
          query getCollectionProducts(
            \$handle: String!
          ) {
            collection(handle: \$handle) {
              products(first: 20) {
                edges {
                  node {
                    id
                    title
                    descriptionHtml
                    vendor
                    featuredImage {
                      url
                      altText
                    }
                    variants(first: 1) {
                      edges {
                        node {
                          price {
                            amount
                            currencyCode
                          }
                          compareAtPrice {
                            amount
                            currencyCode
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        ''',
        'variables': {'handle': handle},
      }),
    );

    if (response.statusCode != 200) {
      return [];
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final edges = body['data']?['collection']?['products']?['edges']
              as List<dynamic>? ??
          const [];

      return edges.map((edge) {
        final node =
            (edge as Map<String, dynamic>)['node'] as Map<String, dynamic>? ??
                <String, dynamic>{};
        final variantEdge =
            ((node['variants']?['edges'] as List<dynamic>?) ?? const [])
                    .isNotEmpty
                ? (node['variants']?['edges'] as List<dynamic>).first
                        as Map<String, dynamic>? ??
                    <String, dynamic>{}
                : <String, dynamic>{};
        final variant = (variantEdge['node'] as Map<String, dynamic>? ??
            <String, dynamic>{});
        final priceMap =
            variant['price'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final compareAtPriceMap =
            variant['compareAtPrice'] as Map<String, dynamic>? ??
                <String, dynamic>{};
        final price = _readMoney(priceMap['amount']);
        final compareAtPrice = _readMoney(compareAtPriceMap['amount']);

        return ProductModel.fromShopifyMap({
          'title': node['title'],
          'vendor': node['vendor'],
          'description': node['descriptionHtml'],
          'imageUrl': node['featuredImage']?['url'],
          'price': price,
          'salePrice': compareAtPrice > 0 ? compareAtPrice : price,
          'discountPercent': compareAtPrice > price && compareAtPrice > 0
              ? ((1 - (price / compareAtPrice)) * 100).round()
              : null,
        });
      }).toList();
    } catch (error, stackTrace) {
      debugPrint('Shopify collection products parsing error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  Future<List<ProductModel>> fetchProducts({int first = 8}) async {
    const storeDomain = 'mimsico.myshopify.com';
    const accessToken = '92c151ad07a7a610b0aeb4003d375f59';

    if (accessToken.isEmpty) {
      debugPrint('Shopify token is empty.');
      return [];
    }

    final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': accessToken,
      },
      body: jsonEncode({
        'query': '''
          query getProducts(
            \$first: Int!
          ) {
            products(first: \$first, sortKey: TITLE) {
              edges {
                node {
                  id
                  title
                  descriptionHtml
                  vendor
                  featuredImage {
                    url
                    altText
                  }
                  variants(first: 1) {
                    edges {
                      node {
                        price {
                          amount
                          currencyCode
                        }
                        compareAtPrice {
                          amount
                          currencyCode
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        ''',
        'variables': {'first': first},
      }),
    );

    if (response.statusCode != 200) {
      debugPrint(
        'Shopify request failed: ${response.statusCode} ${response.body}',
      );
      return [];
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final edges =
          body['data']?['products']?['edges'] as List<dynamic>? ?? const [];

      return edges.map((edge) {
        final node =
            (edge as Map<String, dynamic>)['node'] as Map<String, dynamic>? ??
                <String, dynamic>{};
        final variantEdge =
            ((node['variants']?['edges'] as List<dynamic>?) ?? const [])
                    .isNotEmpty
                ? (node['variants']?['edges'] as List<dynamic>).first
                        as Map<String, dynamic>? ??
                    <String, dynamic>{}
                : <String, dynamic>{};
        final variant = (variantEdge['node'] as Map<String, dynamic>? ??
            <String, dynamic>{});
        final priceMap =
            variant['price'] as Map<String, dynamic>? ?? <String, dynamic>{};
        final compareAtPriceMap =
            variant['compareAtPrice'] as Map<String, dynamic>? ??
                <String, dynamic>{};
        final price = _readMoney(priceMap['amount']);
        final compareAtPrice = _readMoney(compareAtPriceMap['amount']);

        return ProductModel.fromShopifyMap({
          'title': node['title'],
          'vendor': node['vendor'],
          'description': node['descriptionHtml'],
          'imageUrl': node['featuredImage']?['url'],
          'price': price,
          'salePrice': compareAtPrice > 0 ? compareAtPrice : price,
          'discountPercent': compareAtPrice > price && compareAtPrice > 0
              ? ((1 - (price / compareAtPrice)) * 100).round()
              : null,
        });
      }).toList();
    } catch (error, stackTrace) {
      debugPrint('Shopify response parsing error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  double _readMoney(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}
