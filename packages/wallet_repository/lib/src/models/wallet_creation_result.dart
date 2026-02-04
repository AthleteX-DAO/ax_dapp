/// Result of wallet creation with recovery phrase
class WalletCreationResult {
  const WalletCreationResult({
    required this.address,
    required this.privateKeyHex,
    required this.recoveryPhrase,
  });

  /// The wallet address (hex string with 0x prefix)
  final String address;
  
  /// The private key in hexadecimal format
  final String privateKeyHex;
  
  /// The 12-word recovery phrase
  final String recoveryPhrase;
  
  /// Split recovery phrase into individual words
  List<String> get recoveryWords => recoveryPhrase.split(' ');
  
  /// Check if wallet creation was successful
  bool get isValid => address.isNotEmpty && recoveryPhrase.isNotEmpty;
}
