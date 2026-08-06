import 'package:busniness/constants.dart';

String _stringOrFallback(dynamic value, String fallback) {
  final text = value as String?;
  if (text == null || text.trim().isEmpty) {
    return fallback;
  }
  return text;
}

class ProductModel {
  final String image;
  final String brandName;
  final String title;
  final List<String> images;
  final String? shopifyId;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final String? description;
  final bool isBookmarked;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.images = const [],
    this.shopifyId,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.description,
    this.isBookmarked = false,
  });

  String get bookmarkKey {
    if (shopifyId != null && shopifyId!.trim().isNotEmpty) {
      return shopifyId!;
    }
    return '${brandName.toLowerCase().trim()}::${title.toLowerCase().trim()}';
  }

  ProductModel copyWith({
    String? image,
    String? brandName,
    String? title,
    List<String>? images,
    String? shopifyId,
    double? price,
    double? priceAfetDiscount,
    int? dicountpercent,
    String? description,
    bool? isBookmarked,
  }) {
    return ProductModel(
      image: image ?? this.image,
      brandName: brandName ?? this.brandName,
      title: title ?? this.title,
      images: images ?? this.images,
      shopifyId: shopifyId ?? this.shopifyId,
      price: price ?? this.price,
      priceAfetDiscount: priceAfetDiscount ?? this.priceAfetDiscount,
      dicountpercent: dicountpercent ?? this.dicountpercent,
      description: description ?? this.description,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  factory ProductModel.fromShopifyMap(Map<String, dynamic> data) {
    final title = _stringOrFallback(data['title'], 'Untitled product');
    final brandName = _stringOrFallback(data['vendor'], 'Store');

    final rawImages = (data['images'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .where((url) => url.trim().isNotEmpty)
        .toList();

    final imageUrl = _stringOrFallback(data['imageUrl'], productDemoImg1);
    final image = rawImages.isNotEmpty ? rawImages.first : imageUrl;

    final price = (data['price'] as num?)?.toDouble() ?? 0.0;
    final salePrice = (data['salePrice'] as num?)?.toDouble();
    final discountPercent = data['discountPercent'] as int?;
    final description = data['description'] as String?;

    final hasDiscount = salePrice != null && salePrice > 0 && salePrice < price;

    return ProductModel(
      image: image,
      images: rawImages.isNotEmpty ? rawImages : [image],
      shopifyId: data['shopifyId'] as String?,
      brandName: brandName,
      title: title,
      price: price,
      priceAfetDiscount: hasDiscount ? salePrice : null,
      dicountpercent: hasDiscount ? discountPercent : null,
      description: description,
      isBookmarked: (data['isBookmarked'] as bool?) ?? false,
    );
  }

  factory ProductModel.fromPickMap(Map<String, dynamic> data) {
    final image = _stringOrFallback(data['image'], productDemoImg1);
    final brandName = _stringOrFallback(data['brand_name'], 'Store');
    final title = _stringOrFallback(data['title'], 'Product');
    final price = (data['price'] as num?)?.toDouble() ?? 0.0;
    final salePrice = (data['sale_price'] as num?)?.toDouble();
    final discountPercent = data['discount_percent'] as int?;
    final description = data['description'] as String?;
    final shopifyId = data['shopify_id'] as String?;

    return ProductModel(
      image: image,
      images: [image],
      shopifyId: shopifyId,
      brandName: brandName,
      title: title,
      price: price,
      priceAfetDiscount: salePrice,
      dicountpercent: discountPercent,
      description: description,
      isBookmarked: true,
    );
  }
}
