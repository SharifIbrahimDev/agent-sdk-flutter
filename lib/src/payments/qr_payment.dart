/// A utility class for handling QR codes for payments.
class QRPaymentHelper {
  /// Generates a QR code payload string for a Stellar payment request.
  /// 
  /// Example implementation using SEP-0007 URI Scheme:
  /// `web+stellar:pay?destination=GABC...&amount=10.0&asset_code=USDC`
  static String generatePaymentRequestURI({
    required String destinationAccountId,
    String? amount,
    String? assetCode,
    String? assetIssuer,
    String? memo,
    String? memoType,
  }) {
    final uriBuilder = StringBuffer('web+stellar:pay?destination=$destinationAccountId');
    
    if (amount != null) {
      uriBuilder.write('&amount=$amount');
    }
    if (assetCode != null) {
      uriBuilder.write('&asset_code=$assetCode');
    }
    if (assetIssuer != null) {
      uriBuilder.write('&asset_issuer=$assetIssuer');
    }
    if (memo != null) {
      uriBuilder.write('&memo=$memo');
    }
    if (memoType != null) {
      uriBuilder.write('&memo_type=$memoType');
    }

    return uriBuilder.toString();
  }

  /// Parses a Stellar payment request URI string.
  static Map<String, String> parsePaymentRequestURI(String uriString) {
    if (!uriString.startsWith('web+stellar:pay?')) {
      throw const FormatException('Invalid Stellar SEP-0007 payment URI');
    }
    
    final uri = Uri.parse(uriString.replaceFirst('web+stellar:', 'http://'));
    return uri.queryParameters;
  }
}
