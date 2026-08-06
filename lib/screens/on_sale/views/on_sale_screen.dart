import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/shopify_service.dart';

class OnSaleScreen extends StatefulWidget {
  const OnSaleScreen({super.key});

  @override
  State<OnSaleScreen> createState() => _OnSaleScreenState();
}

class _OnSaleScreenState extends State<OnSaleScreen> {
  late final Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _loadSaleProducts();
  }

  Future<List<ProductModel>> _loadSaleProducts() async {
    final products = await ShopifyService().fetchProducts(first: 40);
    return products
        .where((product) => product.priceAfetDiscount != null)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flash Sale',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Limited-time offers curated for the season.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Could not load products'));
                  }

                  final products = snapshot.data ?? <ProductModel>[];
                  if (products.isEmpty) {
                    return const Center(child: Text('No products on sale'));
                  }

                  return GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        press: () {
                          Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: product,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
