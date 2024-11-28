class PaystackResponse {
  final bool status;
  final dynamic data;

  PaystackResponse({required this.status, required this.data});

  factory PaystackResponse.fromJson(Map<String, dynamic> json) {
    return PaystackResponse(
      status: json['status'],
      data: json['data'],
    );
  }
}
