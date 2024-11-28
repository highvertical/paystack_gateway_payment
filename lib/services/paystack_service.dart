import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paystack_gateway_payment/logger.dart';
import '../models/paystack_response.dart';
import '../utils/paystack_exception.dart';

class PaystackService {
  final String secretKey;
  static const String _baseUrl = 'https://api.paystack.co';

  PaystackService({required this.secretKey});

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);

  Future<PaystackResponse> initializeTransaction({
    required String email,
    required int amount,
    required String callbackUrl,
    String? reference,
    List<String>? channels,
    String currency = 'NGN',
  }) async {
    Logger.logInfo('Initializing transaction for $email with amount $amount');

    if (amount <= 0) {
      throw PaystackException('Amount must be greater than zero');
    }

    if (!_isValidEmail(email)) {
      throw PaystackException('Invalid email format');
    }

    if (!Uri.parse(callbackUrl).isAbsolute) {
      throw PaystackException('Invalid callback URL');
    }

    final url = Uri.parse('$_baseUrl/transaction/initialize');
    final headers = {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'email': email,
      'amount': amount,
      'callback_url': callbackUrl,
      'reference': reference ?? _generateReference(),
      'currency': currency,
      if (channels != null && channels.isNotEmpty) 'channels': channels,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return PaystackResponse.fromJson(jsonDecode(response.body));
      } else {
        throw PaystackException(
            'Failed to initialize transaction: ${response.body}',
            response.statusCode);
      }
    } catch (e) {
      Logger.logError('Transaction initialization failed: $e');
      rethrow;
    }
  }

  Future<PaystackResponse> verifyTransaction(String reference) async {
    final url = Uri.parse('$_baseUrl/transaction/verify/$reference');
    final headers = {'Authorization': 'Bearer $secretKey'};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return PaystackResponse.fromJson(jsonDecode(response.body));
      } else {
        throw PaystackException(
            'Verification Failed: ${response.body}', response.statusCode);
      }
    } catch (e) {
      Logger.logError('Transaction verification failed: $e');
      rethrow;
    }
  }

  String _generateReference() => 'REF_${DateTime.now().millisecondsSinceEpoch}';
}
