import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/shopify_service.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ShopifyService().fetchProducts(first: 8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding,
            ),
            sliver: FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  debugPrint('Bookmark products error: ${snapshot.error}');
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('Could not load products')),
                  );
                }

                final products = snapshot.data ?? <ProductModel>[];
                if (products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('No products available')),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    return ProductCard(
                      image: products[index].image,
                      brandName: products[index].brandName,
                      title: products[index].title,
                      price: products[index].price,
                      priceAfetDiscount: products[index].priceAfetDiscount,
                      dicountpercent: products[index].dicountpercent,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: products[index],
                        );
                      },
                    );
                  }, childCount: products.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
