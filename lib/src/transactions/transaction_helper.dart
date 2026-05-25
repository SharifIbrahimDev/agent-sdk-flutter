import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

/// A helper class for managing Stellar transactions.
class TransactionHelper {
  final StellarSDK _sdk;

  TransactionHelper({StellarSDK? sdk})
      : _sdk = sdk ?? StellarSDK.TESTNET;

  /// Builds a simple payment transaction.
  Future<Transaction> buildPaymentTransaction({
    required KeyPair sourceAccountKeyPair,
    required String destinationAccountId,
    required String amount,
    required Asset asset,
    String? memoText,
  }) async {
    // 1. Fetch the source account sequence number
    AccountResponse sourceAccount =
        await _sdk.accounts.account(sourceAccountKeyPair.accountId);

    // 2. Build the payment operation
    PaymentOperation paymentOperation = PaymentOperationBuilder(
            destinationAccountId, asset, amount)
        .build();

    // 3. Build the transaction
    TransactionBuilder builder = TransactionBuilder(sourceAccount)
        .addOperation(paymentOperation);

    if (memoText != null) {
      builder.addMemo(MemoText(memoText));
    }

    return builder.build();
  }

  /// Submits a signed transaction to the Stellar network.
  Future<SubmitTransactionResponse> submitTransaction(Transaction transaction) async {
    return await _sdk.submitTransaction(transaction);
  }
}
