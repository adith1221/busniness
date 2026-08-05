import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/models/product_model.dart';
import 'package:busniness/route/route_constants.dart';

class _CartEntry {
  _CartEntry({required this.product});

  final ProductModel product;
  int quantity = 1;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final List<_CartEntry> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [
      _CartEntry(
        product: ProductModel(
          image: productDemoImg1,
          brandName: 'MIMSICO',
          title: 'Soft Knit Overshirt',
          price: 89.0,
          priceAfetDiscount: 69.0,
          dicountpercent: 22,
        ),
      ),
      _CartEntry(
        product: ProductModel(
          image: productDemoImg4,
          brandName: 'SHOP',
          title: 'Weekend Carry Tote',
          price: 54.0,
          priceAfetDiscount: 44.0,
          dicountpercent: 18,
        ),
      ),
    ];
  }

  double _unitPrice(ProductModel product) {
    return product.priceAfetDiscount ?? product.price;
  }

  double _lineTotal(_CartEntry entry) {
    return _unitPrice(entry.product) * entry.quantity;
  }

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, entry) => sum + _lineTotal(entry));
  }

  double get _shipping {
    return _cartItems.isEmpty ? 0.0 : 8.0;
  }

  double get _total {
    return _subtotal + _shipping;
  }

  int get _itemCount {
    return _cartItems.fold(0, (sum, entry) => sum + entry.quantity);
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity += 1;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    '$_itemCount items',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                itemCount: _cartItems.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: defaultPadding),
                itemBuilder: (context, index) {
                  final entry = _cartItems[index];
                  final product = entry.product;
                  final lineTotal = _lineTotal(entry);

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
                          child: NetworkImageWithLoader(product.image),
                        ),
                        const SizedBox(width: defaultPadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brandName.toUpperCase(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text('₹${lineTotal.toStringAsFixed(0)}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _decreaseQuantity(index),
                                    icon:
                                        const Icon(Icons.remove_circle_outline),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text('${entry.quantity}'),
                                  ),
                                  IconButton(
                                    onPressed: () => _increaseQuantity(index),
                                    icon: const Icon(Icons.add_circle_outline),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _decreaseQuantity(index),
                          icon: const Icon(Icons.delete_outline),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
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
                  _summaryRow(context, 'Subtotal', _subtotal),
                  _summaryRow(context, 'Shipping', _shipping),
                  _summaryRow(context, 'Total', _total, isTotal: true),
                  const SizedBox(height: defaultPadding),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cartItems.isEmpty
                          ? null
                          : () => Navigator.pushNamed(
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
          Text(
            label,
            style: isTotal
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: isTotal
                ? Theme.of(context).textTheme.titleSmall
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
