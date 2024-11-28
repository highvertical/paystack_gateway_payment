import 'package:flutter/material.dart';
import '../services/paystack_service.dart';
import '../paystack_webview.dart';
import '../models/paystack_transaction_result.dart';

class PaystackButton extends StatefulWidget {
  final PaystackService paystackService;
  final String email;
  final int amount;
  final String callbackUrl;
  final List<String>? channels;
  final String buttonText;
  final Color buttonColor;
  final Icon? buttonIcon;

  const PaystackButton({
    required this.paystackService,
    required this.email,
    required this.amount,
    required this.callbackUrl,
    this.channels,
    this.buttonText = 'Pay with Paystack',
    this.buttonColor = Colors.blue,
    this.buttonIcon,
    super.key,
  });

  @override
  State<PaystackButton> createState() => _PaystackButtonState();
}

class _PaystackButtonState extends State<PaystackButton> {
  bool _isLoading = false;

  Future<void> _handlePayment(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.paystackService.initializeTransaction(
        email: widget.email,
        amount: widget.amount,
        callbackUrl: widget.callbackUrl,
        channels: widget.channels,
      );

      final authorizationUrl = response.data?['authorization_url'];
      if (authorizationUrl != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaystackWebView(
              authorizationUrl: authorizationUrl,
              title: 'Pay with Paystack',
            ),
          ),
        ) as PaystackTransactionResult;

        // Handle result
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment successful: ${result.reference}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed: ${result.message}')),
          );
        }
      } else {
        throw Exception('Authorization URL is missing.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: widget.buttonColor),
      icon: widget.buttonIcon ?? const Icon(Icons.payment),
      label: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(widget.buttonText),
      onPressed: _isLoading ? null : () => _handlePayment(context),
    );
  }
}
