/// Represents a Stellar wallet with its key pair and metadata.
class StellarWallet {
  /// The public address (account ID) of this wallet.
  final String accountId;

  /// The secret seed of this wallet. Keep this private and never share it!
  final String secretSeed;

  /// Optional label for the wallet (e.g. "Main Wallet", "Agent Wallet").
  final String? label;

  /// The timestamp when this wallet was created.
  final DateTime createdAt;

  const StellarWallet({
    required this.accountId,
    required this.secretSeed,
    this.label,
    required this.createdAt,
  });

  /// Returns a safe representation without exposing the secret seed.
  @override
  String toString() {
    return 'StellarWallet(accountId: $accountId, label: $label, createdAt: $createdAt)';
  }

  /// Converts the wallet to a JSON map.
  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'secretSeed': secretSeed,
        'label': label,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Creates a [StellarWallet] from a JSON map.
  factory StellarWallet.fromJson(Map<String, dynamic> json) {
    return StellarWallet(
      accountId: json['accountId'] as String,
      secretSeed: json['secretSeed'] as String,
      label: json['label'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
