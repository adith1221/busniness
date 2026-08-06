import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/services/picks_service.dart';

import '../../../constants.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  late Future<List<ProductModel>> _picksFuture;

  @override
  void initState() {
    super.initState();
    _picksFuture = PicksService().fetchPicks();
  }

  Future<void> _refresh() async {
    setState(() {
      _picksFuture = PicksService().fetchPicks();
    });
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
              future: _picksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('Could not load picks')),
                  );
                }

                final products = snapshot.data ?? <ProductModel>[];
                if (products.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(child: Text('No picks yet')),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
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
                        isBookmarked: true,
                        onBookmarkChanged: (isBookmarked) {
                          if (!isBookmarked) {
                            _refresh();
                          }
                        },
                        press: () async {
                          await Navigator.pushNamed(
                            context,
                            productDetailsScreenRoute,
                            arguments: product,
                          );
                          if (mounted) {
                            _refresh();
                          }
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
