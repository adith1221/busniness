import 'package:flutter/material.dart';
import 'package:busniness/components/network_image_with_loader.dart';
import 'package:busniness/constants.dart';

class ReturnOrderDetailsScreen extends StatefulWidget {
  const ReturnOrderDetailsScreen({super.key, this.order});

  final Map<String, dynamic>? order;

  @override
  State<ReturnOrderDetailsScreen> createState() =>
      _ReturnOrderDetailsScreenState();
}

class _ReturnOrderDetailsScreenState extends State<ReturnOrderDetailsScreen> {
  late final List<_OrderItemData> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _OrderItemData(
        image: 'https://i.imgur.com/CGCyp1d.png',
        name: 'Classic Denim Jacket',
        size: 'M',
        color: 'Navy Blue',
        quantity: 1,
        price: 79.99,
        deliveryStatus: 'Delivered',
      ),
      _OrderItemData(
        image: 'https://i.imgur.com/AkzWQuJ.png',
        name: 'Minimal Sneakers',
        size: '41',
        color: 'White',
        quantity: 1,
        price: 54.5,
        deliveryStatus: 'In Transit',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final orderData = {
      'id': widget.order?['id'] ?? '#1001',
      'date': widget.order?['date'] ?? 'July 20, 2026',
      'deliveryDate': widget.order?['deliveryDate'] ?? 'July 22, 2026',
      'paymentMethod': widget.order?['paymentMethod'] ?? 'Credit Card',
      'status': widget.order?['status'] ?? 'Delivered',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            _OrderSummaryCard(orderData: orderData),
            const SizedBox(height: defaultPadding),
            Text(
              'Ordered items',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            ..._items.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: _OrderItemCard(
                      item: entry.value,
                      onQuantityChanged: (value) {
                        setState(() {
                          _items[entry.key] =
                              _items[entry.key].copyWith(quantity: value);
                        });
                      },
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.orderData});

  final Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ${orderData['id']}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: defaultPadding),
          _InfoRow(label: 'Order Date', value: orderData['date'] as String),
          const SizedBox(height: defaultPadding / 2),
          _InfoRow(
            label: 'Delivery Date',
            value: orderData['deliveryDate'] as String,
          ),
          const SizedBox(height: defaultPadding / 2),
          _InfoRow(
            label: 'Payment Method',
            value: orderData['paymentMethod'] as String,
          ),
          const SizedBox(height: defaultPadding / 2),
          _InfoRow(label: 'Order Status', value: orderData['status'] as String),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item, required this.onQuantityChanged});

  final _OrderItemData item;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadious),
                child: SizedBox(
                  width: 88,
                  height: 88,
                  child: NetworkImageWithLoader(
                    item.image,
                    radius: defaultBorderRadious,
                  ),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    _InfoRow(label: 'Size', value: item.size),
                    const SizedBox(height: defaultPadding / 4),
                    _InfoRow(label: 'Color', value: item.color),
                    const SizedBox(height: defaultPadding / 4),
                    Row(
                      children: [
                        SizedBox(
                          width: 96,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: item.quantity > 1
                                    ? () => onQuantityChanged(item.quantity - 1)
                                    : null,
                                icon: const Icon(Icons.remove_circle_outline),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('${item.quantity}'),
                              ),
                              IconButton(
                                onPressed: item.quantity < 3
                                    ? () => onQuantityChanged(item.quantity + 1)
                                    : null,
                                icon: const Icon(Icons.add_circle_outline),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding / 4),
                    _InfoRow(
                        label: 'Price',
                        value: '\$${item.price.toStringAsFixed(2)}'),
                    const SizedBox(height: defaultPadding / 4),
                    _InfoRow(
                        label: 'Delivery Status', value: item.deliveryStatus),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
              ),
              child: const Text('Request Return'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _OrderItemData {
  const _OrderItemData({
    required this.image,
    required this.name,
    required this.size,
    required this.color,
    required this.quantity,
    required this.price,
    required this.deliveryStatus,
  });

  final String image;
  final String name;
  final String size;
  final String color;
  final int quantity;
  final double price;
  final String deliveryStatus;

  _OrderItemData copyWith({int? quantity}) {
    return _OrderItemData(
      image: image,
      name: name,
      size: size,
      color: color,
      quantity: quantity ?? this.quantity,
      price: price,
      deliveryStatus: deliveryStatus,
    );
  }
}
