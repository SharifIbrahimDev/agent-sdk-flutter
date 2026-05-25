import 'package:flutter/material.dart';
import 'package:agent_sdk/agent_sdk.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as sdk;

void main() {
  runApp(const AgentSdkExampleApp());
}

class AgentSdkExampleApp extends StatelessWidget {
  const AgentSdkExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agent SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DefaultTabController(
        length: 4,
        child: ExampleHomeScreen(),
      ),
    );
  }
}

class ExampleHomeScreen extends StatelessWidget {
  const ExampleHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent SDK Example'),
        bottom: const TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Wallet'),
            Tab(text: 'Invoice'),
            Tab(text: 'Scanner'),
            Tab(text: 'Balances'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          WalletTab(),
          InvoiceTab(),
          ScannerTab(),
          BalancesTab(),
        ],
      ),
    );
  }
}

class WalletTab extends StatefulWidget {
  const WalletTab({Key? key}) : super(key: key);

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  StellarWallet? _wallet;
  final AgentService _agentService = AgentService();

  void _generateWallet() {
    setState(() {
      _wallet = _agentService.createAgentWallet(label: 'Demo Agent Wallet');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _generateWallet,
            child: const Text('Generate New Agent Wallet'),
          ),
          const SizedBox(height: 24),
          if (_wallet != null) ...[
            const Text('Generated Wallet:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Label: ${_wallet!.label}'),
            const SizedBox(height: 8),
            const Text('Account ID (Public Key):'),
            SelectableText(_wallet!.accountId),
            const SizedBox(height: 8),
            const Text('Secret Seed: (KEEP SAFE)'),
            SelectableText(_wallet!.secretSeed ?? 'N/A'),
          ] else ...[
            const Center(child: Text('Press the button to generate a wallet.')),
          ]
        ],
      ),
    );
  }
}

class InvoiceTab extends StatefulWidget {
  const InvoiceTab({Key? key}) : super(key: key);

  @override
  State<InvoiceTab> createState() => _InvoiceTabState();
}

class _InvoiceTabState extends State<InvoiceTab> {
  final _accountIdController = TextEditingController();
  final _amountController = TextEditingController();
  String? _invoiceUri;

  @override
  void dispose() {
    _accountIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _generateInvoice() {
    if (_accountIdController.text.isEmpty || _amountController.text.isEmpty) return;
    
    final uri = QRPaymentHelper.generatePaymentRequestURI(
      destinationAccountId: _accountIdController.text,
      amount: _amountController.text,
      assetCode: 'XLM',
    );
    
    setState(() {
      _invoiceUri = uri;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
            controller: _accountIdController,
            decoration: const InputDecoration(labelText: 'Destination Account ID (G...)'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Amount (XLM)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _generateInvoice,
            child: const Text('Generate Invoice QR'),
          ),
          const SizedBox(height: 24),
          if (_invoiceUri != null) ...[
            const Text('Payment Request URI:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_invoiceUri!),
            const SizedBox(height: 16),
            Center(
              child: QrImageView(
                data: _invoiceUri!,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class ScannerTab extends StatefulWidget {
  const ScannerTab({Key? key}) : super(key: key);

  @override
  State<ScannerTab> createState() => _ScannerTabState();
}

class _ScannerTabState extends State<ScannerTab> {
  final _uriController = TextEditingController();
  Map<String, String>? _parsedData;
  String? _error;

  @override
  void dispose() {
    _uriController.dispose();
    super.dispose();
  }

  void _parseUri() {
    setState(() {
      _parsedData = null;
      _error = null;
    });
    
    try {
      final parsed = QRPaymentHelper.parsePaymentRequestURI(_uriController.text);
      setState(() {
        _parsedData = parsed;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Paste a web+stellar:pay URI here to simulate scanning a QR code:'),
          const SizedBox(height: 8),
          TextField(
            controller: _uriController,
            decoration: const InputDecoration(
              hintText: 'web+stellar:pay?destination=...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _parseUri,
            child: const Text('Parse URI'),
          ),
          const SizedBox(height: 24),
          if (_error != null)
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
          if (_parsedData != null) ...[
            const Text('Parsed Data:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _parsedData!.entries.map((e) {
                  return ListTile(
                    title: Text(e.key),
                    subtitle: Text(e.value),
                  );
                }).toList(),
              ),
            )
          ]
        ],
      ),
    );
  }
}

class BalancesTab extends StatefulWidget {
  const BalancesTab({Key? key}) : super(key: key);

  @override
  State<BalancesTab> createState() => _BalancesTabState();
}

class _BalancesTabState extends State<BalancesTab> {
  final _accountIdController = TextEditingController();
  final WalletService _walletService = WalletService();
  List<sdk.Balance>? _balances;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _accountIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchBalances() async {
    if (_accountIdController.text.isEmpty) return;
    
    setState(() {
      _loading = true;
      _error = null;
      _balances = null;
    });

    try {
      final balances = await _walletService.getBalances(_accountIdController.text);
      setState(() {
        _balances = balances;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _accountIdController,
            decoration: const InputDecoration(labelText: 'Account ID (G...)'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loading ? null : _fetchBalances,
            child: _loading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Fetch Balances (Testnet)'),
          ),
          const SizedBox(height: 24),
          if (_error != null)
            Text('Error: $_error', style: const TextStyle(color: Colors.red)),
          if (_balances != null) ...[
            const Text('Balances:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _balances!.map((b) {
                  return ListTile(
                    title: Text(b.assetType == sdk.Asset.TYPE_NATIVE ? 'XLM' : b.assetCode ?? 'Unknown'),
                    subtitle: Text('Balance: ${b.balance}'),
                  );
                }).toList(),
              ),
            )
          ]
        ],
      ),
    );
  }
}
