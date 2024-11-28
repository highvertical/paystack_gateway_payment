import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paystack_gateway_payment/widgets/paystack_button.dart';
import 'package:paystack_gateway_payment/services/paystack_service.dart';

void main() {
  testWidgets('PaystackButton renders correctly', (WidgetTester tester) async {
    final service = PaystackService(secretKey: 'sk_test_example');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PaystackButton(
            paystackService: service,
            email: 'test@example.com',
            amount: 1000,
            callbackUrl: 'https://example.com/callback',
            onSuccess: (success) {},
            onError: (error) {},
          ),
        ),
      ),
    );

    expect(find.text('Pay with Paystack'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
