import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:busniness/models/product_model.dart';
import 'package:busniness/services/picks_service.dart';

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
  final PicksService _picksService = PicksService();

  Future<List<ShopifyCollection>> fetchCollections() async {
    const storeDomain = 'mimsico.myshopify.com';
    const accessToken = '92c151ad07a7a610b0aeb4003d375f59';

    if (accessToken.isEmpty) {
      return [];
    }

    try {
      final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
      final response = await _postGraphql(
        uri: uri,
        accessToken: accessToken,
        body: jsonEncode({
          'query': '''
            query getCollections {
              collections(first: 250, sortKey: TITLE) {
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
        debugPrint(
          'Shopify collections request failed: ${response.statusCode} ${response.body}',
        );
        return [];
      }

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
      debugPrint('Shopify collections request error: $error');
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

    try {
      final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
      final response = await _postGraphql(
        uri: uri,
        accessToken: accessToken,
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
                      images(first: 10) {
                        edges {
                          node {
                            url
                            altText
                          }
                        }
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
        debugPrint(
          'Shopify collection products request failed: ${response.statusCode} ${response.body}',
        );
        return [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final edges = body['data']?['collection']?['products']?['edges']
              as List<dynamic>? ??
          const [];

      final products = edges.map((edge) {
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

        final currentPrice = _readMoney(priceMap['amount']);
        final compareAtPrice = _readMoney(compareAtPriceMap['amount']);
        final hasDiscount = compareAtPrice > currentPrice && compareAtPrice > 0;

        return ProductModel.fromShopifyMap({
          'shopifyId': node['id'],
          'title': node['title'],
          'vendor': node['vendor'],
          'description': node['descriptionHtml'],
          'imageUrl': _readFirstImageUrl(node),
          'images': _readImageUrls(node),
          'price': hasDiscount ? compareAtPrice : currentPrice,
          'salePrice': hasDiscount ? currentPrice : null,
          'discountPercent': hasDiscount
              ? ((1 - (currentPrice / compareAtPrice)) * 100).round()
              : null,
        });
      }).toList();
      return _attachBookmarks(products);
    } catch (error, stackTrace) {
      debugPrint('Shopify collection products request error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  Future<List<ProductModel>> fetchProducts({int first = 8}) async {
    return _fetchProducts(first: first);
  }

  /// Fetches products with a Shopify product tag. Pass `null` to fetch all
  /// products. The tag value must match the tag configured in Shopify.
  Future<List<ProductModel>> fetchProductsByTag({
    String? tag,
    int first = 50,
  }) async {
    return _fetchProducts(first: first, tag: tag);
  }

  Future<List<ProductModel>> _fetchProducts({
    required int first,
    String? tag,
  }) async {
    const storeDomain = 'mimsico.myshopify.com';
    const accessToken = '92c151ad07a7a610b0aeb4003d375f59';

    if (accessToken.isEmpty) {
      debugPrint('Shopify token is empty.');
      return [];
    }

    try {
      final uri = Uri.https(storeDomain, '/api/2024-04/graphql.json');
      final response = await _postGraphql(
        uri: uri,
        accessToken: accessToken,
        body: jsonEncode({
          'query': '''
            query getProducts(
              \$first: Int!
              \$query: String
            ) {
              products(first: \$first, sortKey: TITLE, query: \$query) {
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
                    images(first: 10) {
                      edges {
                        node {
                          url
                          altText
                        }
                      }
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
          'variables': {
            'first': first,
            'query': tag == null || tag.trim().isEmpty
                ? null
                : 'tag:${_shopifySearchValue(tag)}',
          },
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Shopify request failed: ${response.statusCode} ${response.body}',
        );
        return [];
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final edges =
          body['data']?['products']?['edges'] as List<dynamic>? ?? const [];

      final products = edges.map((edge) {
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

        final currentPrice = _readMoney(priceMap['amount']);
        final compareAtPrice = _readMoney(compareAtPriceMap['amount']);
        final hasDiscount = compareAtPrice > currentPrice && compareAtPrice > 0;

        return ProductModel.fromShopifyMap({
          'shopifyId': node['id'],
          'title': node['title'],
          'vendor': node['vendor'],
          'description': node['descriptionHtml'],
          'imageUrl': _readFirstImageUrl(node),
          'images': _readImageUrls(node),
          'price': hasDiscount ? compareAtPrice : currentPrice,
          'salePrice': hasDiscount ? currentPrice : null,
          'discountPercent': hasDiscount
              ? ((1 - (currentPrice / compareAtPrice)) * 100).round()
              : null,
        });
      }).toList();
      return _attachBookmarks(products);
    } catch (error, stackTrace) {
      debugPrint('Shopify request error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return [];
    }
  }

  Future<http.Response> _postGraphql({
    required Uri uri,
    required String accessToken,
    required String body,
    int retries = 2,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _client.post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'X-Shopify-Storefront-Access-Token': accessToken,
          },
          body: body,
        );

        if (response.statusCode == 200) {
          return response;
        }

        if (response.statusCode >= 500 && attempt < retries) {
          await Future<void>.delayed(const Duration(milliseconds: 400));
          continue;
        }

        return response;
      } on SocketException catch (error) {
        lastError = error;
        if (attempt >= retries) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } on HttpException catch (error) {
        lastError = error;
        if (attempt >= retries) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } on http.ClientException catch (error) {
        lastError = error;
        if (attempt >= retries) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 400));
      } catch (error) {
        lastError = error;
        if (attempt >= retries) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
    }

    if (lastError != null) {
      throw lastError;
    }

    throw const SocketException('Shopify request failed');
  }

  String _shopifySearchValue(String value) {
    final trimmed = value.trim();
    return trimmed.contains(' ') ? '"$trimmed"' : trimmed;
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

  String _readFirstImageUrl(Map<String, dynamic> node) {
    final images = _readImageUrls(node);
    if (images.isNotEmpty) {
      return images.first;
    }

    final featured = node['featuredImage'];
    if (featured is Map<String, dynamic>) {
      final url = featured['url'] as String?;
      if (url != null && url.trim().isNotEmpty) {
        return url;
      }
    }

    return '';
  }

  List<String> _readImageUrls(Map<String, dynamic> node) {
    final urls = <String>[];

    final images = node['images'];
    if (images is Map<String, dynamic>) {
      final edges = images['edges'] as List<dynamic>? ?? const [];
      for (final edge in edges) {
        if (edge is Map<String, dynamic>) {
          final imageNode = edge['node'];
          if (imageNode is Map<String, dynamic>) {
            final url = imageNode['url'] as String?;
            if (url != null && url.trim().isNotEmpty && !urls.contains(url)) {
              urls.add(url);
            }
          }
        }
      }
    }

    if (urls.isEmpty) {
      final featured = node['featuredImage'];
      if (featured is Map<String, dynamic>) {
        final url = featured['url'] as String?;
        if (url != null && url.trim().isNotEmpty) {
          urls.add(url);
        }
      }
    }

    return urls;
  }

  Future<List<ProductModel>> _attachBookmarks(
      List<ProductModel> products) async {
    if (products.isEmpty) {
      return products;
    }

    final bookmarkedKeys = await _picksService.fetchPickKeys();
    if (bookmarkedKeys.isEmpty) {
      return products;
    }

    return products
        .map(
          (product) => product.copyWith(
            isBookmarked: bookmarkedKeys.contains(product.bookmarkKey),
          ),
        )
        .toList();
  }
}
