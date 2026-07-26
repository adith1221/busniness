import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = <String>[
      '123 Market Street\nNew York, NY 10001',
      '88 Ocean Avenue\nLos Angeles, CA 90001',
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saved Addresses',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.separated(
                  itemCount: addresses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.home_outlined),
                        title: Text('Address ${index + 1}'),
                        subtitle: Text(addresses[index]),
                        trailing: const Icon(Icons.edit_outlined),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
