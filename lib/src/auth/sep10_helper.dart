/// A helper class for SEP-10 Web Authentication.
///
/// SEP-10 is a Stellar Ecosystem Proposal for authenticating users
/// with a Stellar account, allowing them to prove ownership of a keypair.
///
/// See: https://stellar.org/protocol/sep-10
class Sep10Helper {
  final String _serverHomeDomain;
  final String _webAuthEndpoint;

  Sep10Helper({
    required String serverHomeDomain,
    String? webAuthEndpoint,
  })  : _serverHomeDomain = serverHomeDomain,
        _webAuthEndpoint =
            webAuthEndpoint ?? 'https://$serverHomeDomain/auth';

  /// Returns the home domain for this SEP-10 server.
  String get homeDomain => _serverHomeDomain;

  /// Returns the web auth endpoint URL.
  String get webAuthEndpoint => _webAuthEndpoint;

  /// Builds the challenge request URL for a given account.
  ///
  /// The client fetches this URL to get a challenge transaction.
  String buildChallengeUrl(String accountId, {String? memo}) {
    final params = StringBuffer('?account=$accountId');
    if (memo != null) {
      params.write('&memo=$memo');
    }
    params.write('&home_domain=$_serverHomeDomain');
    return '$_webAuthEndpoint$params';
  }

  /// Validates the structure of a JWT token returned after SEP-10 auth.
  ///
  /// A valid JWT has three dot-separated base64 parts.
  static bool isValidJwt(String token) {
    final parts = token.split('.');
    return parts.length == 3 && parts.every((p) => p.isNotEmpty);
  }

  /// Extracts the account ID from a decoded SEP-10 JWT sub claim.
  ///
  /// The sub field can be in the format:
  /// - `GABC...` (simple account)
  /// - `GABC...:0` (account with memo)
  static String extractAccountFromJwtSub(String sub) {
    return sub.split(':').first;
  }
}
