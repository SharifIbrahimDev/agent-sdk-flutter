import 'package:flutter_test/flutter_test.dart';
import 'package:agent_sdk/agent_sdk.dart';

void main() {
  group('WalletService', () {
    test('generates a valid keypair', () {
      final walletService = WalletService();
      final keyPair = walletService.generateWallet();
      expect(keyPair.accountId, isNotEmpty);
      expect(keyPair.accountId, startsWith('G'));
    });
  });

  group('QRPaymentHelper', () {
    test('generates valid payment URI', () {
      const destination = 'GABC1234567890';
      final uri = QRPaymentHelper.generatePaymentRequestURI(
        destinationAccountId: destination,
        amount: '10.0',
        assetCode: 'XLM',
      );
      expect(uri, startsWith('web+stellar:pay?destination=$destination'));
      expect(uri, contains('amount=10.0'));
      expect(uri, contains('asset_code=XLM'));
    });

    test('parses payment URI correctly', () {
      const uri = 'web+stellar:pay?destination=GABC&amount=5.0&asset_code=USDC';
      final params = QRPaymentHelper.parsePaymentRequestURI(uri);
      expect(params['destination'], equals('GABC'));
      expect(params['amount'], equals('5.0'));
      expect(params['asset_code'], equals('USDC'));
    });
  });
}
