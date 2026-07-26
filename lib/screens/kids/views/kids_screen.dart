import 'package:flutter/material.dart';
import 'package:busniness/components/product/product_card.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';

class KidsScreen extends StatelessWidget {
  const KidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kidsProducts = <ProductModel>[
      ProductModel(
        image: productDemoImg2,
        brandName: 'KID',
        title: 'Mini Everyday Set',
        price: 42.0,
        priceAfetDiscount: 34.0,
        dicountpercent: 19,
      ),
      ProductModel(
        image: productDemoImg3,
        brandName: 'KID',
        title: 'Soft Play Jacket',
        price: 49.0,
      ),
      ProductModel(
        image: productDemoImg1,
        brandName: 'KID',
        title: 'Weekend Knit Layers',
        price: 38.0,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Text('For Kids', style: Theme.of(context).textTheme.headlineSmall),
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
                itemCount: kidsProducts.length,
                itemBuilder: (context, index) {
                  final product = kidsProducts[index];
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
