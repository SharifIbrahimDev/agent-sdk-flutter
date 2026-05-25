# agent_sdk Example

A Flutter example app demonstrating how to use the `agent_sdk` package.

## Features Demonstrated

- **Wallet Generation** — Create a new Stellar keypair using `AgentService`
- **QR Payment URI** — Generate a SEP-0007 payment request URI using `QRPaymentHelper`
- **Model Serialization** — `StellarWallet` and `PaymentRequest` JSON support

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

## Key Code

```dart
// Generate a wallet
final agentService = AgentService();
final wallet = agentService.createAgentWallet(label: 'My Agent');
print(wallet.accountId); // GABC...

// Generate QR payment URI
final uri = QRPaymentHelper.generatePaymentRequestURI(
  destinationAccountId: wallet.accountId,
  amount: '10.0',
  assetCode: 'XLM',
);
print(uri); // web+stellar:pay?destination=GABC...
```
