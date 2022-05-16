class SwapInfo {
  final double toPrice;
  final double minimumReceived;
  final double priceImpact;
  final double receiveAmount;
  final double totalFee;

  factory SwapInfo.empty() {
    return SwapInfo(
        toPrice: 0.0,
        minimumReceived: 0.0,
        priceImpact: 0.0,
        receiveAmount: 0.0,
        totalFee: 0.0);
  }
  SwapInfo(
      {required this.toPrice,
      required this.minimumReceived,
      required this.priceImpact,
      required this.receiveAmount,
      required this.totalFee});
}

