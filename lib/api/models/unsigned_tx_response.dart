class UnsignedTxResponse {
  const UnsignedTxResponse({
    required this.to,
    required this.data,
    required this.chainId,
    this.value = '0',
    this.gasEstimate,
  });

  factory UnsignedTxResponse.fromJson(Map<String, dynamic> json) {
    return UnsignedTxResponse(
      to: json['to'] as String,
      data: json['data'] as String,
      value: json['value'] as String? ?? '0',
      gasEstimate: json['gas_estimate'] as int?,
      chainId: json['chain_id'] as int,
    );
  }

  final String to;
  final String data;
  final String value;
  final int? gasEstimate;
  final int chainId;
}
