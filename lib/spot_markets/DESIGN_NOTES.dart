/// Spot Markets Design & Performance Notes
/// 
/// Design System: Glass Morphism (matching Prediction page)
/// - Gradient: LinearGradient([Colors.white.withOpacity(0.08), 0.06])
/// - Border: Colors.white.withOpacity(0.1), width 1.5
/// - Border radius: 14-20px
/// - No solid gray backgrounds (transparent white only)
/// - Typography: use textStyle() utility for consistency
///
/// Performance Optimizations:
/// - Event filtering in bloc: only selected market refreshes on OrderSettled
/// - Staggered polling: one market updated every 15s, rotating through all markets
/// - Single market fetch: _fetchSingleMarketPrice() for efficiency
/// - Resource cleanup: close() cancels subscription and timer
/// - Event validation: _isEventForMarket() checks marketId
///
/// Component Styling:
/// - Chart container: dark glass (Colors.black.withOpacity(0.2))
/// - Change badge: background changeColor.withOpacity(0.15), border 0.3
/// - Selected highlight: primaryOrangeColor.withOpacity(0.15)
/// - All inputs: glass background (Colors.white.withOpacity(0.04))
///
/// Files Modified:
/// - lib/spot_markets/view/desktop_spot_markets_page.dart
/// - lib/spot_markets/widgets/spot_market_chart.dart
/// - lib/spot_markets/widgets/spot_order_form.dart
/// - lib/spot_markets/bloc/spot_markets_bloc.dart
