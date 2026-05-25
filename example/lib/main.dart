import 'package:agent_sdk/agent_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AgentSdkExampleApp());
}

class AgentSdkExampleApp extends StatelessWidget {
  const AgentSdkExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgentLabs SDK Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D5AFE),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'monospace',
      ),
      home: const WalletDemoPage(),
    );
  }
}

class WalletDemoPage extends StatefulWidget {
  const WalletDemoPage({super.key});

  @override
  State<WalletDemoPage> createState() => _WalletDemoPageState();
}

class _WalletDemoPageState extends State<WalletDemoPage> {
  final AgentService _agentService = AgentService();
  StellarWallet? _wallet;
  String? _qrUri;

  void _generateWallet() {
    setState(() {
      _wallet = _agentService.createAgentWallet(label: 'Demo Agent Wallet');
      if (_wallet != null) {
        _qrUri = QRPaymentHelper.generatePaymentRequestURI(
          destinationAccountId: _wallet!.accountId,
          amount: '10.0',
          assetCode: 'XLM',
          memo: 'Demo Payment',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgentLabs SDK Demo'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionCard(
              title: '🔐 Wallet Generator',
              child: Column(
                children: [
                  const Text(
                    'Generate a new Stellar wallet keypair using the AgentLabs SDK.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _generateWallet,
                    icon: const Icon(Icons.wallet),
                    label: const Text('Generate Wallet'),
                  ),
                ],
              ),
            ),
            if (_wallet != null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: '📋 Wallet Details',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KeyValueRow(label: 'Label', value: _wallet!.label ?? '-'),
                    const Divider(),
                    _KeyValueRow(
                      label: 'Account ID',
                      value: _wallet!.accountId,
                      monospace: true,
                    ),
                    const Divider(),
                    _KeyValueRow(
                      label: 'Secret Seed',
                      value: '${_wallet!.secretSeed.substring(0, 8)}••••••••',
                      monospace: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: '📱 QR Payment URI',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SEP-0007 payment request URI:'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _qrUri ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool monospace;

  const _KeyValueRow({
    required this.label,
    required this.value,
    this.monospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontFamily: monospace ? 'monospace' : null,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
