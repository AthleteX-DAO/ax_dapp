/// Unified data model for trade/betting slips across all market types.
///
/// Used by [TradeSlipCard], [TradeSlipDialog], and [LiveTradeTicket].

/// The type of market the slip represents.
enum SlipType {
  /// Prediction market (YES/NO binary outcome).
  prediction,

  /// Spot market (buy/sell synth tokens).
  spot,

  /// Perpetual market (future support).
  perp,
}

/// The side of the trade.
enum SlipSide {
  /// Prediction: betting YES.
  yes,

  /// Prediction: betting NO.
  no,

  /// Spot/Perp: buying the asset.
  buy,

  /// Spot/Perp: selling the asset.
  sell,
}

/// Current status of the trade.
enum SlipStatus {
  /// Transaction submitted, waiting for confirmation.
  pending,

  /// Transaction confirmed on-chain.
  confirmed,

  /// Transaction failed or reverted.
  failed,

  /// Market has settled (prediction only).
  settled,
}

/// Unified slip data for all market types.
class TradeSlipData {
  const TradeSlipData({
    required this.type,
    required this.side,
    required this.status,
    required this.marketName,
    required this.amount,
    required this.price,
    required this.timestamp,
    this.currentPrice,
    this.potentialPayout,
    this.unrealizedPnl,
    this.txHash,
    this.marketAddress,
    this.walletAddress,
    this.quantity,
    this.slippage,
    this.yesPrice,
    this.noPrice,
    this.marketId,
  });

  /// The market type.
  final SlipType type;

  /// Which side the user took.
  final SlipSide side;

  /// Current status of the trade.
  final SlipStatus status;

  /// Human-readable market name.
  ///
  /// Prediction: "Will Aiyuk be traded?"
  /// Spot: "AX/axUSD"
  final String marketName;

  /// Amount wagered/traded in axUSD.
  final double amount;

  /// Entry price or odds.
  ///
  /// Prediction: 0.65 (YES token price)
  /// Spot: 2.35 (token price in USD)
  final double price;

  /// Live price for P/L calculation. Updated by [LiveTradeTicket].
  final double? currentPrice;

  /// Prediction: amount / price (potential payout if correct).
  final double? potentialPayout;

  /// Unrealized P/L based on currentPrice vs entry price.
  final double? unrealizedPnl;

  /// On-chain transaction hash.
  final String? txHash;

  /// Contract address for this market.
  final String? marketAddress;

  /// User's wallet address.
  final String? walletAddress;

  /// Spot: number of synth tokens received.
  final double? quantity;

  /// Spot: slippage tolerance used.
  final double? slippage;

  /// Prediction: current YES token price (for live updates).
  final double? yesPrice;

  /// Prediction: current NO token price (for live updates).
  final double? noPrice;

  /// Spot: numeric market ID (for API calls).
  final int? marketId;

  /// When the trade was placed.
  final DateTime timestamp;

  /// Create a copy with updated fields (for live updates).
  TradeSlipData copyWith({
    SlipStatus? status,
    double? currentPrice,
    double? unrealizedPnl,
    double? yesPrice,
    double? noPrice,
    String? txHash,
  }) {
    return TradeSlipData(
      type: type,
      side: side,
      status: status ?? this.status,
      marketName: marketName,
      amount: amount,
      price: price,
      currentPrice: currentPrice ?? this.currentPrice,
      potentialPayout: potentialPayout,
      unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
      txHash: txHash ?? this.txHash,
      marketAddress: marketAddress,
      walletAddress: walletAddress,
      quantity: quantity,
      slippage: slippage,
      yesPrice: yesPrice ?? this.yesPrice,
      noPrice: noPrice ?? this.noPrice,
      marketId: marketId,
      timestamp: timestamp,
    );
  }
}
