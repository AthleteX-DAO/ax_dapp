class SpotQuoteData {
  const SpotQuoteData({
    required this.inputAmount,
    required this.outputAmount,
    required this.fee,
    required this.side,
  });

  factory SpotQuoteData.fromJson(Map<String, dynamic> json) {
    return SpotQuoteData(
      inputAmount: json['input_amount'] as String? ?? '0',
      outputAmount: json['output_amount'] as String? ?? '0',
      fee: json['fee'] as String? ?? '0',
      side: json['side'] as String? ?? 'buy',
    );
  }

  final String inputAmount;
  final String outputAmount;
  final String fee;
  final String side;
}
