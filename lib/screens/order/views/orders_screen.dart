import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = <Map<String, String>>[
      {'id': '#1042', 'status': 'Delivered', 'date': 'July 20, 2026'},
      {'id': '#1043', 'status': 'In Transit', 'date': 'July 24, 2026'},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Orders',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      child: ListTile(
                        title: Text(order['id'] ?? ''),
                        subtitle: Text(order['date'] ?? ''),
                        trailing: Chip(label: Text(order['status'] ?? '')),
                      ),
                    );
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
