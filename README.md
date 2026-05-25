# 🌟 agent-sdk-flutter

<p align="center">
  <strong>A professional Flutter SDK for Stellar agent banking, merchant payments, and financial inclusion.</strong><br/>
  Built for emerging markets. Powered by the Stellar network.
</p>

<p align="center">
  <a href="https://github.com/SharifIbrahimDev/agent-sdk-flutter/actions/workflows/flutter.yml">
    <img src="https://github.com/SharifIbrahimDev/agent-sdk-flutter/actions/workflows/flutter.yml/badge.svg" alt="CI Status"/>
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"/>
  </a>
  <img src="https://img.shields.io/badge/Flutter-%3E%3D3.0-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Stellar-Network-7B16FF?logo=stellar" alt="Stellar"/>
  <img src="https://img.shields.io/badge/SEP--10-Auth-green" alt="SEP-10"/>
  <img src="https://img.shields.io/badge/SEP--0007-QR%20Payments-orange" alt="SEP-0007"/>
</p>

---

## 🚀 Overview

`agent-sdk-flutter` is a comprehensive, open-source Flutter SDK for building **agent banking applications** on the **Stellar blockchain**. It is designed from the ground up for financial inclusion in **emerging markets** — giving developers easy, reliable tools to build wallet management, merchant invoicing, QR payments, and authentication flows.

This SDK is the core package of the **AgentLabs ecosystem** — an open platform for agent banking, POS operations, and digital payments.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🔑 **Wallet Management** | Generate and manage Stellar keypairs for agents and merchants |
| 🏪 **Merchant Service** | Onboard merchants, create invoices, check balances |
| 🤖 **Agent Service** | Onboard field agents and manage their wallets |
| 📱 **QR Payments** | Generate and parse SEP-0007 `web+stellar:pay` payment URIs |
| 🔐 **SEP-10 Auth** | Web Authentication challenge/response and JWT validation |
| 💳 **Transaction Helper** | Build and submit Stellar payments with ease |
| 🧪 **Fully Tested** | 20+ unit tests covering all core functionality |
| ⚡ **CI/CD** | GitHub Actions workflow with automated `flutter analyze` and `flutter test` |

---

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  agent_sdk:
    git:
      url: https://github.com/SharifIbrahimDev/agent-sdk-flutter.git
```

Then run:

```bash
flutter pub get
```

---

## 🛠️ Usage

### 1. Generate a Wallet

```dart
import 'package:agent_sdk/agent_sdk.dart';

final agentService = AgentService();
final wallet = agentService.createAgentWallet(label: 'Field Agent - Lagos');

print(wallet.accountId);   // G...
print(wallet.secretSeed);  // S... (keep safe!)
```

### 2. Create a Merchant Invoice (QR Payment)

```dart
final helper = QRPaymentHelper;
final uri = helper.generatePaymentRequestURI(
  destinationAccountId: 'GABC...XYZ',
  amount: '50.00',
  assetCode: 'XLM',
);

print(uri); // web+stellar:pay?destination=GABC...XYZ&amount=50.00&asset_code=XLM
```

### 3. Parse a Payment URI

```dart
final params = QRPaymentHelper.parsePaymentRequestURI(uri);
print(params['destination']); // GABC...XYZ
print(params['amount']);      // 50.00
```

### 4. SEP-10 Web Authentication

```dart
final sep10 = Sep10Helper(serverHomeDomain: 'myanchor.com');
final challengeUrl = sep10.buildChallengeUrl('GABC...XYZ');

// Validate a JWT returned after authentication
final isValid = Sep10Helper.isValidJwt(token);
final accountId = Sep10Helper.extractAccountFromJwtSub(token);
```

### 5. Check Balances (Testnet)

```dart
final walletService = WalletService();
final balances = await walletService.getBalances('GABC...XYZ');

for (final balance in balances) {
  print('${balance.assetCode}: ${balance.balance}');
}
```

---

## 📁 Project Structure

```
agent-sdk-flutter/
├── lib/
│   ├── agent_sdk.dart              ← Public entry point
│   └── src/
│       ├── agent/                  ← AgentService
│       ├── auth/                   ← Sep10Helper
│       ├── merchant/               ← MerchantService
│       ├── models/                 ← StellarWallet, PaymentRequest
│       ├── payments/               ← QRPaymentHelper
│       ├── transactions/           ← TransactionHelper
│       └── wallet/                 ← WalletService
├── example/                        ← Full example Flutter app
├── test/                           ← 20+ unit tests
└── .github/workflows/              ← CI/CD automation
```

---

## 🗺️ Roadmap

- [x] Wallet generation (Agent & Merchant)
- [x] QR Payment URI generation & parsing (SEP-0007)
- [x] SEP-10 Web Authentication helpers
- [x] Merchant invoicing service
- [x] Example Flutter application
- [ ] SEP-24 deposit/withdrawal flow helpers
- [ ] Multi-signature transaction support
- [ ] Offline transaction queue with local persistence
- [ ] Real-time payment notifications via event stream
- [ ] Path payment support
- [ ] pub.dev release

> See all planned features in our [GitHub Issues](https://github.com/SharifIbrahimDev/agent-sdk-flutter/issues).

---

## 🤝 Contributing

We warmly welcome contributions! Whether you're fixing bugs, writing docs, or building new features — there's a place for you here.

- 📋 Browse [open issues](https://github.com/SharifIbrahimDev/agent-sdk-flutter/issues) — look for `good first issue` to get started
- 📖 Read our [Contributing Guidelines](CONTRIBUTING.md)
- 💬 Review our [Code of Conduct](CODE_OF_CONDUCT.md)

---

## 🌍 About AgentLabs

AgentLabs is building open-source financial infrastructure for emerging markets, powered by the **Stellar blockchain**. Our mission is to make digital payments and agent banking accessible to underserved communities across Africa and beyond.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
