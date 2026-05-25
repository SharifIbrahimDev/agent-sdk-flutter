import 'package:agent_sdk/agent_sdk.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as sdk;

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

    test('throws on invalid URI', () {
      expect(
        () => QRPaymentHelper.parsePaymentRequestURI('https://invalid.com'),
        throwsFormatException,
      );
    });
  });

  group('StellarWallet', () {
    test('serializes to and from JSON', () {
      final wallet = StellarWallet(
        accountId: 'GABC123',
        secretSeed: 'SABC123',
        label: 'Test Wallet',
        createdAt: DateTime(2025, 1, 1),
      );
      final json = wallet.toJson();
      final restored = StellarWallet.fromJson(json);
      expect(restored.accountId, equals(wallet.accountId));
      expect(restored.secretSeed, equals(wallet.secretSeed));
      expect(restored.label, equals(wallet.label));
    });

    test('toString does not expose seed', () {
      final wallet = StellarWallet(
        accountId: 'GABC123',
        secretSeed: 'SABC123',
        createdAt: DateTime.now(),
      );
      expect(wallet.toString(), contains('GABC123'));
      expect(wallet.toString(), isNot(contains('SABC123')));
    });
  });

  group('PaymentRequest', () {
    test('isNative returns true for XLM with no issuer', () {
      const req = PaymentRequest(
        destinationAccountId: 'GABC',
        amount: '10',
        assetCode: 'XLM',
      );
      expect(req.isNative, isTrue);
    });

    test('isNative returns false for non-XLM asset', () {
      const req = PaymentRequest(
        destinationAccountId: 'GABC',
        amount: '10',
        assetCode: 'USDC',
        assetIssuer: 'GISSUER123',
      );
      expect(req.isNative, isFalse);
    });

    test('serializes to and from JSON', () {
      const req = PaymentRequest(
        destinationAccountId: 'GABC',
        amount: '5.0',
        assetCode: 'USDC',
        assetIssuer: 'GISSUER',
        memo: 'payment',
      );
      final json = req.toJson();
      final restored = PaymentRequest.fromJson(json);
      expect(restored.destinationAccountId, equals(req.destinationAccountId));
      expect(restored.amount, equals(req.amount));
      expect(restored.assetCode, equals(req.assetCode));
      expect(restored.memo, equals(req.memo));
    });
  });

  group('AgentService', () {
    test('creates a valid agent wallet', () {
      final agentService = AgentService();
      final wallet = agentService.createAgentWallet(label: 'Field Agent');
      expect(wallet.accountId, startsWith('G'));
      expect(wallet.secretSeed, startsWith('S'));
      expect(wallet.label, equals('Field Agent'));
    });

    test('uses default label when not provided', () {
      final agentService = AgentService();
      final wallet = agentService.createAgentWallet();
      expect(wallet.label, equals('Agent Wallet'));
    });
  });

  group('MerchantService', () {
    test('creates a valid merchant wallet', () {
      final merchantService = MerchantService();
      final wallet = merchantService.createMerchantWallet(merchantName: 'Super Store');
      expect(wallet.accountId, startsWith('G'));
      expect(wallet.secretSeed, startsWith('S'));
      expect(wallet.label, equals('Super Store'));
    });

    test('uses default label when merchantName is not provided', () {
      final merchantService = MerchantService();
      final wallet = merchantService.createMerchantWallet();
      expect(wallet.label, equals('Merchant Wallet'));
    });

    test('creates a valid invoice', () {
      final merchantService = MerchantService();
      final invoice = merchantService.createInvoice(
        merchantAccountId: 'GABC123',
        amount: '25.50',
        assetCode: 'USDC',
        assetIssuer: 'GISSUER',
        invoiceReference: 'INV-001',
      );
      expect(invoice.destinationAccountId, equals('GABC123'));
      expect(invoice.amount, equals('25.50'));
      expect(invoice.assetCode, equals('USDC'));
      expect(invoice.assetIssuer, equals('GISSUER'));
      expect(invoice.memo, equals('INV-001'));
      expect(invoice.memoType, equals('text'));
    });

    test('fetches merchant balances using custom wallet service', () async {
      final mockWallet = MockWalletService();
      final merchantService = MerchantService(walletService: mockWallet);
      final balances = await merchantService.getMerchantBalances('GABC123');
      expect(balances, isEmpty);
    });
  });

  group('Sep10Helper', () {
    test('initializes with home domain and constructs correct auth endpoint', () {
      final helper = Sep10Helper(serverHomeDomain: 'example.com');
      expect(helper.homeDomain, equals('example.com'));
      expect(helper.webAuthEndpoint, equals('https://example.com/auth'));
    });

    test('uses custom auth endpoint if provided', () {
      final helper = Sep10Helper(
        serverHomeDomain: 'example.com',
        webAuthEndpoint: 'https://auth.example.com/login',
      );
      expect(helper.webAuthEndpoint, equals('https://auth.example.com/login'));
    });

    test('builds challenge URL correctly', () {
      final helper = Sep10Helper(serverHomeDomain: 'example.com');
      final url = helper.buildChallengeUrl('GABC123', memo: '12345');
      expect(url, startsWith('https://example.com/auth'));
      expect(url, contains('account=GABC123'));
      expect(url, contains('memo=12345'));
      expect(url, contains('home_domain=example.com'));
    });

    test('isValidJwt validates structures properly', () {
      expect(Sep10Helper.isValidJwt('a.b.c'), isTrue);
      expect(Sep10Helper.isValidJwt('abc.def'), isFalse);
      expect(Sep10Helper.isValidJwt('a.b.'), isFalse);
    });

    test('extractAccountFromJwtSub handles sub claim structure correctly', () {
      expect(Sep10Helper.extractAccountFromJwtSub('GABC123:123'), equals('GABC123'));
      expect(Sep10Helper.extractAccountFromJwtSub('GABC555'), equals('GABC555'));
    });
  });
}

class MockWalletService extends WalletService {
  @override
  Future<List<sdk.Balance>> getBalances(String accountId) async {
    return <sdk.Balance>[];
  }
}

