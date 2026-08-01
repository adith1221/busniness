import 'package:busniness/route/router.dart' as router;
import 'package:busniness/route/route_constants.dart';
import 'package:busniness/screens/checkout/views/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Checkout navigates to the payment screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const CartScreen(),
        onGenerateRoute: router.generateRoute,
      ),
    );

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Payment'), findsOneWidget);
    expect(find.text('Secure checkout'), findsOneWidget);
  });
}
