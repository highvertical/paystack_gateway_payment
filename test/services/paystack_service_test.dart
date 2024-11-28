import 'package:flutter_test/flutter_test.dart';
import 'package:paystack_gateway_payment/services/paystack_service.dart';
import 'package:paystack_gateway_payment/utils/paystack_exception.dart';

void main() {
  group('PaystackService Tests', () {
    final service = PaystackService(secretKey: 'sk_test_example');

    test('Invalid email throws exception', () {
      expect(
        () => service.initializeTransaction(
          email: 'invalid-email',
          amount: 5000,
          callbackUrl: 'https://example.com/callback',
        ),
        throwsA(isA<PaystackException>()),
      );
    });

    test('Amount less than zero throws exception', () {
      expect(
        () => service.initializeTransaction(
          email: 'test@example.com',
          amount: -1,
          callbackUrl: 'https://example.com/callback',
        ),
        throwsA(isA<PaystackException>()),
      );
    });
  });
}
