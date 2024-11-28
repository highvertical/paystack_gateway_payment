import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'models/paystack_transaction_result.dart';

class PaystackWebView extends StatefulWidget {
  final String authorizationUrl;
  final String title; // Customizable title

  const PaystackWebView({
    required this.authorizationUrl,
    this.title = 'Complete Payment',
    super.key,
  });

  @override
  State<PaystackWebView> createState() => _PaystackWebViewState();
}

class _PaystackWebViewState extends State<PaystackWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('success')) {
              Navigator.pop(
                context,
                PaystackTransactionResult(
                  success: true,
                  message: 'Payment Successful',
                  reference: _extractReference(request.url),
                ),
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('cancel')) {
              Navigator.pop(
                context,
                PaystackTransactionResult(
                  success: false,
                  message: 'Payment Cancelled',
                ),
              );
              return NavigationDecision.prevent;
            } else if (request.url.contains('error')) {
              Navigator.pop(
                context,
                PaystackTransactionResult(
                  success: false,
                  message: 'Payment Failed or Encountered an Error',
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            Navigator.pop(
              context,
              PaystackTransactionResult(
                success: false,
                message: 'Web resource error: ${error.description}',
              ),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  String? _extractReference(String url) {
    Uri uri = Uri.parse(url);
    return uri.queryParameters['reference'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
