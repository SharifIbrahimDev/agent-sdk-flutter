import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

import '../models/stellar_wallet.dart';
import '../wallet/wallet_service.dart';

/// A high-level service for managing agent banking operations.
///
/// Agents are financial intermediaries who facilitate cash-in, cash-out,
/// and merchant payments on behalf of customers.
class AgentService {
  final WalletService _walletService;

  AgentService({WalletService? walletService})
      : _walletService = walletService ?? WalletService();

  /// Creates a new agent wallet.
  ///
  /// Returns a [StellarWallet] containing the account ID and secret seed.
  /// **Important:** Store the secret seed securely. It cannot be recovered.
  StellarWallet createAgentWallet({String? label}) {
    final keyPair = _walletService.generateWallet();
    return StellarWallet(
      accountId: keyPair.accountId,
      secretSeed: keyPair.secretSeed,
      label: label ?? 'Agent Wallet',
      createdAt: DateTime.now(),
    );
  }

  /// Retrieves the XLM balance for the given agent account ID.
  Future<String> getAgentXLMBalance(String accountId) async {
    final balances = await _walletService.getBalances(accountId);
    final xlmBalance = balances.firstWhere(
      (b) => b.assetType == 'native',
      orElse: () => throw Exception('No native XLM balance found'),
    );
    return xlmBalance.balance;
  }

  /// Retrieves all balances for the given agent account ID.
  Future<List<Balance>> getAgentAllBalances(String accountId) async {
    return await _walletService.getBalances(accountId);
  }
}
