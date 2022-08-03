class FormatWalletAddress {
  FormatWalletAddress({required this.walletAddress});

  factory FormatWalletAddress.getWalletAddress(String userWalletAddress) {
    final walletAddress = "'$userWalletAddress'";
    return FormatWalletAddress(walletAddress: walletAddress);
  }
  String walletAddress;
}
