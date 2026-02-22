import 'package:equatable/equatable.dart';

/// Represents a perpetual futures order in AthleteX
class PerpsOrderModel extends Equatable {
  const PerpsOrderModel({
    required this.orderId,
    required this.symbol,
    required this.side,
    required this.size,
    required this.price,
    required this.timestamp,
    required this.status,
    required this.txHash,
    this.realizedPnl = 0.0,
    this.unrealizedPnl = 0.0,
    this.collateral = 0.0,
    this.leverage = 1.0,
    this.liquidationPrice = 0.0,
    this.entryPrice = 0.0,
    this.markPrice = 0.0,
    this.funding = 0.0,
  });

  /// Deserialization from JSON
  factory PerpsOrderModel.fromJson(Map<String, dynamic> json) {
    return PerpsOrderModel(
      orderId: json['orderId'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] as String,
      size: (json['size'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      txHash: json['txHash'] as String,
      realizedPnl: (json['realizedPnl'] as num?)?.toDouble() ?? 0.0,
      unrealizedPnl: (json['unrealizedPnl'] as num?)?.toDouble() ?? 0.0,
      collateral: (json['collateral'] as num?)?.toDouble() ?? 0.0,
      leverage: (json['leverage'] as num?)?.toDouble() ?? 1.0,
      liquidationPrice: (json['liquidationPrice'] as num?)?.toDouble() ?? 0.0,
      entryPrice: (json['entryPrice'] as num?)?.toDouble() ?? 0.0,
      markPrice: (json['markPrice'] as num?)?.toDouble() ?? 0.0,
      funding: (json['funding'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Unique order identifier
  final String orderId;

  /// Trading symbol (e.g., 'BTC', 'ETH')
  final String symbol;

  /// Order side: 'LONG' or 'SHORT'
  final String side;

  /// Position size in contract units
  final double size;

  /// Order execution price (fill price)
  final double price;

  /// Order creation timestamp
  final DateTime timestamp;

  /// Order status: 'PENDING', 'CONFIRMED', 'CANCELLED', 'LIQUIDATED'
  final String status;

  /// Transaction hash on blockchain
  final String txHash;

  /// Realized profit/loss for closed positions
  final double realizedPnl;

  /// Unrealized profit/loss for open positions
  final double unrealizedPnl;

  /// Collateral amount deposited for this position
  final double collateral;

  /// Leverage used (e.g., 2.0 = 2x leverage)
  final double leverage;

  /// Price at which position will be liquidated
  final double liquidationPrice;

  /// Entry price of the position
  final double entryPrice;

  /// Current mark price (oracle price)
  final double markPrice;

  /// Accumulated funding payments
  final double funding;

  /// Create a copy with modified fields
  PerpsOrderModel copyWith({
    String? orderId,
    String? symbol,
    String? side,
    double? size,
    double? price,
    DateTime? timestamp,
    String? status,
    String? txHash,
    double? realizedPnl,
    double? unrealizedPnl,
    double? collateral,
    double? leverage,
    double? liquidationPrice,
    double? entryPrice,
    double? markPrice,
    double? funding,
  }) {
    return PerpsOrderModel(
      orderId: orderId ?? this.orderId,
      symbol: symbol ?? this.symbol,
      side: side ?? this.side,
      size: size ?? this.size,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
      realizedPnl: realizedPnl ?? this.realizedPnl,
      unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
      collateral: collateral ?? this.collateral,
      leverage: leverage ?? this.leverage,
      liquidationPrice: liquidationPrice ?? this.liquidationPrice,
      entryPrice: entryPrice ?? this.entryPrice,
      markPrice: markPrice ?? this.markPrice,
      funding: funding ?? this.funding,
    );
  }

  /// Serialization to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'symbol': symbol,
      'side': side,
      'size': size,
      'price': price,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'txHash': txHash,
      'realizedPnl': realizedPnl,
      'unrealizedPnl': unrealizedPnl,
      'collateral': collateral,
      'leverage': leverage,
      'liquidationPrice': liquidationPrice,
      'entryPrice': entryPrice,
      'markPrice': markPrice,
      'funding': funding,
    };
  }

  @override
  List<Object> get props => [
        orderId,
        symbol,
        side,
        size,
        price,
        timestamp,
        status,
        txHash,
        realizedPnl,
        unrealizedPnl,
        collateral,
        leverage,
        liquidationPrice,
        entryPrice,
        markPrice,
        funding,
      ];
}
