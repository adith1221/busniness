import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/services/shopify_service.dart';

class CollectionProductsScreen extends StatefulWidget {
  const CollectionProductsScreen({
    super.key,
    this.collectionHandle,
    this.categoryTitle,
    this.tag,
  });

  final String? collectionHandle;
  final String? categoryTitle;
  final String? tag;

  @override
  State<CollectionProductsScreen> createState() =>
      _CollectionProductsScreenState();
}

class _CollectionProductsScreenState extends State<CollectionProductsScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture =
        widget.collectionHandle != null && widget.collectionHandle!.isNotEmpty
            ? ShopifyService().fetchCollectionProducts(widget.collectionHandle!)
            : widget.tag != null && widget.tag!.trim().isNotEmpty
                ? ShopifyService().fetchProductsByTag(tag: widget.tag)
                : ShopifyService().fetchProducts(first: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (widget.categoryTitle ?? widget.collectionHandle ?? 'Products')
              .replaceAll('-', ' ')
              .toUpperCase(),
        ),
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
                shopifyId: product.shopifyId,
                description: product.description,
                images: product.images,
                isBookmarked: product.isBookmarked,
                press: () {},
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryProductsArguments {
  const CategoryProductsArguments({
    required this.title,
    this.tag,
    this.collectionHandle,
  });

  final String title;
  final String? tag;
  final String? collectionHandle;
}
