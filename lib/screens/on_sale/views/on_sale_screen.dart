import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saleProducts = <ProductModel>[
      ProductModel(
        image: productDemoImg5,
        brandName: 'LIPSY',
        title: 'Summer Drop Essentials',
        price: 120.0,
        priceAfetDiscount: 74.0,
        dicountpercent: 38,
      ),
      ProductModel(
        image: productDemoImg6,
        brandName: 'MIMSICO',
        title: 'Limited Weekend Jacket',
        price: 96.0,
        priceAfetDiscount: 59.0,
        dicountpercent: 38,
      ),
      ProductModel(
        image: productDemoImg4,
        brandName: 'MIMSICO',
        title: 'Travel Layered Tote',
        price: 78.0,
        priceAfetDiscount: 55.0,
        dicountpercent: 29,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Flash Sale', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('Limited-time offers curated for the season.', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: saleProducts.length,
                itemBuilder: (context, index) {
                  final product = saleProducts[index];
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
