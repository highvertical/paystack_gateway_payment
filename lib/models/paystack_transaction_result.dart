class PaystackTransactionResult {
  final bool success;
  final String message;
  final String? reference;

  PaystackTransactionResult({
    required this.success,
    required this.message,
    this.reference,
  });
}
