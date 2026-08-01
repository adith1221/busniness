import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';

import 'return_order_details_screen.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = <Map<String, dynamic>>[
      {
        'id': '#1001',
        'date': 'July 20, 2026',
        'total': 124.99,
        'items': 2,
        'deliveryStatus': 'Delivered',
        'paymentStatus': 'Paid',
        'returnStatus': 'Requested',
      },
      {
        'id': '#1002',
        'date': 'July 24, 2026',
        'total': 89.5,
        'items': 1,
        'deliveryStatus': 'In Transit',
        'paymentStatus': 'Pending',
        'returnStatus': 'Not Requested',
      },
      {
        'id': '#1003',
        'date': 'July 28, 2026',
        'total': 215.0,
        'items': 4,
        'deliveryStatus': 'Delivered',
        'paymentStatus': 'Paid',
        'returnStatus': 'Approved',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Returns'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Previous orders',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _ReturnOrderCard(order: order);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnOrderCard extends StatelessWidget {
  const _ReturnOrderCard({required this.order});

  final Map<String, dynamic> order;

  @override
  Widget build(BuildContext context) {
    final returnStatus = order['returnStatus'] as String;
    final returnColor = _returnColor(returnStatus);

    return InkWell(
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      onTap: () {
        Navigator.pushNamed(
          context,
          returnOrderDetailsScreenRoute,
          arguments: order,
        );
      },
      child: Container(
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ${order['id']}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            _InfoRow(label: 'Order Date', value: order['date'] as String),
            const SizedBox(height: defaultPadding / 4),
            _InfoRow(
              label: 'Total Amount',
              value: '\$${order['total']}',
            ),
            const SizedBox(height: defaultPadding / 4),
            _InfoRow(label: 'Number of Items', value: '${order['items']}'),
            const SizedBox(height: defaultPadding / 4),
            _InfoRow(
                label: 'Delivery Status',
                value: order['deliveryStatus'] as String),
            const SizedBox(height: defaultPadding / 4),
            _InfoRow(
                label: 'Payment Status',
                value: order['paymentStatus'] as String),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                const Expanded(child: Text('Return Status')),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 4,
                  ),
                  decoration: BoxDecoration(
                    color: returnColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    returnStatus,
                    style: TextStyle(
                      color: returnColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _returnColor(String status) {
    switch (status) {
      case 'Requested':
        return warningColor;
      case 'Approved':
        return successColor;
      case 'Rejected':
        return errorColor;
      default:
        return primaryColor;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
