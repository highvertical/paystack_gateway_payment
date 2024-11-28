class PaystackException implements Exception {
  final String message;
  final int? statusCode;

  PaystackException(this.message, [this.statusCode]);

  @override
  String toString() => 'PaystackException: $message (Status Code: $statusCode)';
}
