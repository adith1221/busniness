import 'package:flutter/material.dart';
import 'package:busniness/constants.dart';
import 'package:busniness/route/route_constants.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'Card';

  final List<_PaymentMethod> _methods = const [
    _PaymentMethod(name: 'Card', icon: Icons.credit_card_rounded),
    _PaymentMethod(name: 'PayPal', icon: Icons.account_balance_wallet_rounded),
    _PaymentMethod(name: 'Cash', icon: Icons.money_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Secure checkout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Delivering to Home • 123 Market Street',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              addressesScreenRoute,
                            ),
                            icon: const Icon(Icons.location_on_outlined),
                            label: const Text('Change Address'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ..._methods.map((method) {
                final selected = method.name == _selectedMethod;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => setState(() => _selectedMethod = method.name),
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    child: Container(
                      padding: const EdgeInsets.all(defaultPadding / 1.2),
                      decoration: BoxDecoration(
                        color:
                            selected ? const Color(0xFFF1ECFF) : Colors.white,
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                        border: Border.all(
                          color: selected ? primaryColor : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(method.icon, color: primaryColor),
                          const SizedBox(width: 12),
                          Expanded(child: Text(method.name)),
                          if (selected)
                            const Icon(Icons.check_circle, color: primaryColor),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: defaultPadding),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Promo code',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(defaultBorderRadious),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(defaultBorderRadious),
                ),
                child: Column(
                  children: [
                    _summaryRow(context, 'Subtotal', 121.0),
                    _summaryRow(context, 'Shipping', 8.0),
                    _summaryRow(context, 'Total', 129.0, isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _placeOrder() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order placed'),
          content: const Text(
              'Your order is confirmed. You can track it in My Orders.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  entryPointWithTabScreenRoute,
                  (route) => false,
                  arguments: 0,
                );
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
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

class _PaymentMethod {
  const _PaymentMethod({required this.name, required this.icon});

  final String name;
  final IconData icon;
}
