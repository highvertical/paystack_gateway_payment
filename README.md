# Paystack Gateway Payment

A Flutter package that integrates the Paystack payment gateway to facilitate online transactions. It provides easy-to-use services for initializing and verifying payments, along with a customizable button widget for triggering payments in your Flutter app.

## Features

- Initialize payments securely using Paystack API.
- Verify transaction status.
- Customizable Paystack payment button.
- WebView to handle Paystack payment flow.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  paystack_gateway_payment: ^1.0.0
```
Then run:

``` bash
flutter pub get
```

## Usage
- 1. Set up Paystack Service
To initialize the Paystack service, you need to provide your Paystack secret key:

``` dart
import 'package:paystack_gateway_payment/services/paystack_service.dart';

final paystackService = PaystackService(secretKey: 'your-paystack-secret-key');
```

- 2. Initialize Transaction
To initialize a payment, call the initializeTransaction method with necessary parameters:

``` dart
PaystackResponse response = await paystackService.initializeTransaction(
  email: 'user@example.com',
  amount: 1000,
  callbackUrl: 'https://your-callback-url.com',
);
```

This will return a PaystackResponse with the transaction details, including an authorization URL to complete the payment.

- 3. Payment Button
Use the PaystackButton widget to provide a payment button in your app:

``` dart
import 'package:paystack_gateway_payment/widgets/paystack_button.dart';

PaystackButton(
  paystackService: paystackService,
  email: 'user@example.com',
  amount: 1000,
  callbackUrl: 'https://your-callback-url.com',
  onSuccess: (reference) {
    print('Payment successful: $reference');
  },
  onError: (error) {
    print('Payment error: $error');
  },
)
```

- 4. WebView for Payment Flow
The package includes a PaystackWebView that handles the Paystack payment process:

``` dart
import 'package:paystack_gateway_payment/paystack_webview.dart';

// Navigate to the WebView page with the authorization URL
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PaystackWebView(
      authorizationUrl: response.data['authorization_url'],
      onSuccess: () {
        print('Payment successful');
      },
      onError: (error) {
        print('Payment failed: $error');
      },
    ),
  ),
);
```

### Error Handling
The package includes custom exceptions for error handling. If a transaction fails or there's an invalid parameter, it will throw a PaystackException with a relevant message.

### Example:
``` dart
try {
  // Some payment-related operation
} catch (e) {
  if (e is PaystackException) {
    print('Error: ${e.message}');
  }
}
```

## License
This package is licensed under the MIT License. See the LICENSE file for more details.

## Contributing
Feel free to fork the repository and submit issues or pull requests. Contributions are welcome!

## Contact
For support or inquiries, please reach out to highverticaltechnologies@gmail.com.

``` vbnet

### Key Sections:
1. **Overview**: A brief description of what the package does.
2. **Installation**: Instructions on how to add the package to a Flutter project.
3. **Usage**: Examples of how to use the package, including initializing transactions, using the `PaystackButton`, and handling the payment flow with `PaystackWebView`.
4. **Error Handling**: Explanation of how to catch and handle exceptions.
5. **License**: Information about the package’s license (you can adjust this based on your chosen license).

You can customize the "License" and "Contact" sections based on your needs.
```