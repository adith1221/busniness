import 'package:busniness/entry_point.dart';
import 'package:busniness/route/router.dart' as router;
import 'package:busniness/screens/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Wishlist tap opens the picks tab in EntryPoint', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const ProfileScreen(),
        onGenerateRoute: router.generateRoute,
      ),
    );

    await tester.tap(find.text('Wishlist'));
    await tester.pumpAndSettle();

    expect(find.byType(EntryPoint), findsOneWidget);
  });
}
