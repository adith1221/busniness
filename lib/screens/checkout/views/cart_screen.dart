import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = <ProductModel>[
      ProductModel(
        image: productDemoImg1,
        brandName: 'MIMSICO',
        title: 'Soft Knit Overshirt',
        price: 89.0,
        priceAfetDiscount: 69.0,
        dicountpercent: 22,
      ),
      ProductModel(
        image: productDemoImg4,
        brandName: 'SHOP',
        title: 'Weekend Carry Tote',
        price: 54.0,
        priceAfetDiscount: 44.0,
        dicountpercent: 18,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  Text(
                    'My Cart',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text('${cartItems.length} items',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                itemCount: cartItems.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: defaultPadding),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Container(
                    padding: const EdgeInsets.all(defaultPadding / 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(defaultBorderRadious),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: NetworkImageWithLoader(item.image),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.brandName.toUpperCase(),
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(item.title,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Text(
                                  '₹${item.priceAfetDiscount?.toStringAsFixed(0) ?? item.price.toStringAsFixed(0)}'),
                            ],
                          ),
                        ),
                        const Icon(Icons.delete_outline),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(defaultPadding),
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(defaultBorderRadious),
              ),
              child: Column(
                children: [
                  _summaryRow(context, 'Subtotal', 113.0),
                  _summaryRow(context, 'Shipping', 8.0),
                  _summaryRow(context, 'Total', 121.0, isTotal: true),
                  const SizedBox(height: defaultPadding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        paymentMethodScreenRoute,
                      ),
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(BuildContext context, String label, double value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: isTotal
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text('₹${value.toStringAsFixed(0)}',
              style: isTotal
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
