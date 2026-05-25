import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

import '../models/payment_request.dart';
import '../models/stellar_wallet.dart';
import '../wallet/wallet_service.dart';

/// A service for managing merchant-related operations in the Agent Banking Suite.
///
/// Merchants are businesses or individuals that accept payments via the
/// Stellar network through the platform.
class MerchantService {
  final WalletService _walletService;

  MerchantService({WalletService? walletService})
      : _walletService = walletService ?? WalletService();

  /// Creates a new wallet for a merchant.
  ///
  /// Returns a [StellarWallet] for the merchant.
  StellarWallet createMerchantWallet({String? merchantName}) {
    final keyPair = _walletService.generateWallet();
    return StellarWallet(
      accountId: keyPair.accountId,
      secretSeed: keyPair.secretSeed,
      label: merchantName ?? 'Merchant Wallet',
      createdAt: DateTime.now(),
    );
  }

  /// Creates a [PaymentRequest] for a merchant's invoice.
  ///
  /// This can be used to generate a QR code or payment link.
  PaymentRequest createInvoice({
    required String merchantAccountId,
    required String amount,
    String assetCode = 'XLM',
    String? assetIssuer,
    String? invoiceReference,
  }) {
    return PaymentRequest(
      destinationAccountId: merchantAccountId,
      amount: amount,
      assetCode: assetCode,
      assetIssuer: assetIssuer,
      memo: invoiceReference,
      memoType: invoiceReference != null ? 'text' : null,
    );
  }

  /// Fetches the current balances for a merchant account.
  Future<List<Balance>> getMerchantBalances(String merchantAccountId) async {
    return await _walletService.getBalances(merchantAccountId);
  }
}
