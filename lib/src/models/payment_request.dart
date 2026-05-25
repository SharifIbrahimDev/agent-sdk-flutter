/// Represents a payment request on the Stellar network.
class PaymentRequest {
  /// The destination Stellar account ID.
  final String destinationAccountId;

  /// The amount to send.
  final String amount;

  /// The asset code (e.g. 'XLM', 'USDC').
  final String assetCode;

  /// The asset issuer account ID (null for native XLM).
  final String? assetIssuer;

  /// Optional memo text for the transaction.
  final String? memo;

  /// Optional memo type (text, id, hash).
  final String? memoType;

  const PaymentRequest({
    required this.destinationAccountId,
    required this.amount,
    required this.assetCode,
    this.assetIssuer,
    this.memo,
    this.memoType,
  });

  /// Returns true if this is a native XLM payment.
  bool get isNative => assetCode == 'XLM' && assetIssuer == null;

  /// Converts the payment request to a JSON map.
  Map<String, dynamic> toJson() => {
        'destinationAccountId': destinationAccountId,
        'amount': amount,
        'assetCode': assetCode,
        if (assetIssuer != null) 'assetIssuer': assetIssuer,
        if (memo != null) 'memo': memo,
        if (memoType != null) 'memoType': memoType,
      };

  /// Creates a [PaymentRequest] from a JSON map.
  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      destinationAccountId: json['destinationAccountId'] as String,
      amount: json['amount'] as String,
      assetCode: json['assetCode'] as String,
      assetIssuer: json['assetIssuer'] as String?,
      memo: json['memo'] as String?,
      memoType: json['memoType'] as String?,
    );
  }

  @override
  String toString() =>
      'PaymentRequest(to: $destinationAccountId, amount: $amount $assetCode)';
}
