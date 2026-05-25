import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

/// A service for managing Stellar wallets and accounts within the Agent Banking Suite.
class WalletService {
  final StellarSDK _sdk;

  /// Creates a new [WalletService] instance.
  /// 
  /// Defaults to the test network.
  WalletService({StellarSDK? sdk})
      : _sdk = sdk ?? StellarSDK.TESTNET;

  /// Generates a new random KeyPair for a Stellar account.
  KeyPair generateWallet() {
    return KeyPair.random();
  }

  /// Funds an account on the Testnet using friendbot.
  /// Note: This is only for development/testing.
  Future<bool> fundTestAccount(String accountId) async {
    try {
      return await FriendBot.fundTestAccount(accountId);
    } catch (e) {
      return false;
    }
  }

  /// Checks the balance of a given account ID.
  Future<List<Balance>> getBalances(String accountId) async {
    try {
      AccountResponse account = await _sdk.accounts.account(accountId);
      return account.balances;
    } catch (e) {
      throw Exception('Failed to fetch balances: $e');
    }
  }
}
