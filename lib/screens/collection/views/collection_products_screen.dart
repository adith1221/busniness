import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/services/shopify_service.dart';

class CollectionProductsScreen extends StatefulWidget {
  const CollectionProductsScreen({super.key, required this.collectionHandle});

  final String collectionHandle;

  @override
  State<CollectionProductsScreen> createState() =>
      _CollectionProductsScreenState();
}

class _CollectionProductsScreenState extends State<CollectionProductsScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ShopifyService().fetchCollectionProducts(
      widget.collectionHandle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collectionHandle.replaceAll('-', ' ').toUpperCase()),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || (snapshot.data ?? []).isEmpty) {
            return const Center(child: Text('No products in this collection'));
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                image: product.image,
                brandName: product.brandName,
                title: product.title,
                price: product.price,
                priceAfetDiscount: product.priceAfetDiscount,
                dicountpercent: product.dicountpercent,
                press: () {},
              );
            },
          );
        },
      ),
    );
  }
}
