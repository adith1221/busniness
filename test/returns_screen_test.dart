import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:busniness/screens/returns/views/returns_screen.dart';

void main() {
  testWidgets('ReturnsScreen shows sample return orders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReturnsScreen()));

    expect(find.text('Returns'), findsOneWidget);
    expect(find.text('Order #1001'), findsOneWidget);
    expect(find.text('Delivery Status'), findsWidgets);
  });
}
