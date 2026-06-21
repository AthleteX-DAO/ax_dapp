import 'package:equatable/equatable.dart';

/// Aggregated trading stats for a single wallet address.
class TraderSummary extends Equatable {
  const TraderSummary({
    required this.walletAddress,
    required this.totalVolume,
    required this.tradeCount,
    required this.lastTradeTimestamp,
  });

  final String walletAddress;
  final double totalVolume;
  final int tradeCount;
  final DateTime lastTradeTimestamp;

  /// Truncated wallet address: `0x1234…abcd`
  String get shortAddress {
    if (walletAddress.length <= 10) return walletAddress;
    return '${walletAddress.substring(0, 6)}…${walletAddress.substring(walletAddress.length - 4)}';
  }

  @override
  List<Object?> get props => [
        walletAddress,
        totalVolume,
        tradeCount,
        lastTradeTimestamp,
      ];
}
