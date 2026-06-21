/// Represents the type of swap being executed
enum SwapType {
  /// Direct swap through existing liquidity pool (SubGraph)
  direct,

  /// Aggregated swap routing through multiple DEXes via 1inch
  aggregated,

  /// Cross-chain swap using bridge protocols (Phase 2)
  crossChain,
}

/// Extension methods for [SwapType]
extension SwapTypeX on SwapType {
  /// Returns a user-friendly display name for the swap type
  String get displayName {
    switch (this) {
      case SwapType.direct:
        return 'Direct Pool';
      case SwapType.aggregated:
        return 'Best Route via 1inch';
      case SwapType.crossChain:
        return 'Cross-Chain Swap';
    }
  }

  /// Returns an emoji badge for visual indication
  String get badge {
    switch (this) {
      case SwapType.direct:
        return '🟢';
      case SwapType.aggregated:
        return '🔵';
      case SwapType.crossChain:
        return '🟣';
    }
  }

  /// Returns a color for the swap type indicator
  String get colorHex {
    switch (this) {
      case SwapType.direct:
        return '#4CAF50'; // Green
      case SwapType.aggregated:
        return '#2196F3'; // Blue
      case SwapType.crossChain:
        return '#9C27B0'; // Purple
    }
  }
}
