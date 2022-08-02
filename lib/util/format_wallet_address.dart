class FormatWalletAddress {
  FormatWalletAddress({required this.walletAddress});

  factory FormatWalletAddress.getWalletAddress(String userWalletAddress) {
    final walletInt = BigInt.parse(userWalletAddress);
    final walletAddress = walletInt.toRadixString(16);
    return FormatWalletAddress(walletAddress: walletAddress);
  }
  String walletAddress;
}
