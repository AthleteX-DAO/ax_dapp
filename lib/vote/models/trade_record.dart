import 'package:equatable/equatable.dart';

/// A single trade (swap) record across any exchange vertical.
class TradeRecord extends Equatable {
  const TradeRecord({
    required this.walletAddress,
    required this.side,
    required this.amount,
    required this.price,
    required this.timestamp,
    required this.txHash,
    required this.tokenSymbol,
    required this.marketName,
  });

  final String walletAddress;

  /// `'buy'` or `'sell'`
  final String side;

  final double amount;
  final double price;
  final DateTime timestamp;
  final String txHash;
  final String tokenSymbol;
  final String marketName;

  /// Truncated wallet address: `0x1234…abcd`
  String get shortAddress {
    if (walletAddress.length <= 10) return walletAddress;
    return '${walletAddress.substring(0, 6)}…${walletAddress.substring(walletAddress.length - 4)}';
  }

  @override
  List<Object?> get props => [
        walletAddress,
        side,
        amount,
        price,
        timestamp,
        txHash,
        tokenSymbol,
        marketName,
      ];
}
