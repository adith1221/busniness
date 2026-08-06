import 'package:flutter/material.dart';
import 'package:busniness/route/route_constants.dart';

import '/components/Banner/M/banner_m_with_counter.dart';
import '../../../../components/product/product_card.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';
import '../../../../services/shopify_service.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({super.key});

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ShopifyService().fetchProducts(first: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BannerMWithCounter(
          duration: const Duration(hours: 8),
          text: "Super Flash Sale \n50% Off",
          press: () {},
        ),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Flash sale",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        FutureBuilder<List<ProductModel>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              debugPrint('Flash sale error: ${snapshot.error}');
              return const SizedBox(
                height: 220,
                child: Center(child: Text('Could not load products')),
              );
            }

            final products = snapshot.data ?? <ProductModel>[];
            if (products.isEmpty) {
              return const SizedBox(
                height: 220,
                child: Center(child: Text('No products available')),
              );
            }

            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: defaultPadding,
                    right: index == products.length - 1 ? defaultPadding : 0,
                  ),
                  child: ProductCard(
                    image: products[index].image,
                    brandName: products[index].brandName,
                    title: products[index].title,
                    price: products[index].price,
                    priceAfetDiscount: products[index].priceAfetDiscount,
                    dicountpercent: products[index].dicountpercent,
                    shopifyId: products[index].shopifyId,
                    description: products[index].description,
                    images: products[index].images,
                    isBookmarked: products[index].isBookmarked,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                        arguments: products[index],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
