import 'package:flutter_test/flutter_test.dart';
import 'package:busniness/models/product_model.dart';

void main() {
  group('ProductModel.fromShopifyMap', () {
    test('maps Shopify product data into app product model', () {
      final product = ProductModel.fromShopifyMap({
        'title': 'Test Product',
        'vendor': 'My Store',
        'description': 'A sample product',
        'imageUrl': 'https://cdn.example.com/product.jpg',
        'price': 49.99,
      });

      expect(product.title, 'Test Product');
      expect(product.brandName, 'My Store');
      expect(product.image, 'https://cdn.example.com/product.jpg');
      expect(product.price, 49.99);
      expect(product.priceAfetDiscount, isNull);
    });
  });
}
