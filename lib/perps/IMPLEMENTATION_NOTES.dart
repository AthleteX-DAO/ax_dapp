/// Perps Trading Implementation Reference
/// 
/// Market IDs (Base Sepolia):
/// - BTC: 1, ETH: 2, SOL: 3, BNB: 4, XRP: 5, DOGE: 6, ADA: 7
///
/// Key Contract Methods:
/// - commitOrder(marketId, sizeDelta, limitPrice=0) - Place order
/// - getAvailableMargin(account) - Check margin available
/// - totalAccountValue(account) - Get account value
///
/// Trading Flow:
/// 1. User selects Long/Short direction
/// 2. User chooses Market or Limit order type
/// 3. User enters size (USD amount) and limit price (if limit)
/// 4. PerpsPageBloc submits via PerpsTradingBloc
/// 5. Service calls commitOrder() on smart contract
/// 6. Transaction hash returned to UI
///
/// Features Implemented:
/// ✅ Long/Short buttons, Market/Limit selector, Size + price inputs
/// ✅ Base Sepolia smart contract integration
/// ✅ Transaction submission, Order status feedback
///
/// Future TODOs:
/// - Leverage selection (intentionally omitted)
/// - Actual account creation/management
/// - Balance fetching from contracts
/// - Limit order implementation
/// - Order cancellation, Position tracking
/// - Liquidation price, Fee estimation
