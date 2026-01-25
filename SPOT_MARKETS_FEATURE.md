# Spot Markets Trading Feature

A new desktop page for spot market trading has been added to the AthletexDApp.

## Directory Structure

```
lib/spot_markets/
├── bloc/
│   ├── bloc.dart                    (exports)
│   ├── spot_markets_bloc.dart       (business logic)
│   ├── spot_markets_event.dart      (events)
│   └── spot_markets_state.dart      (states)
├── models/
│   ├── models.dart                  (exports)
│   ├── spot_market_model.dart       (market data model)
│   └── spot_order_model.dart        (order data model)
├── view/
│   ├── view.dart                    (exports)
│   └── desktop_spot_markets_page.dart (main UI)
├── widgets/
│   ├── widgets.dart                 (exports)
│   ├── spot_market_card.dart        (market card widget)
│   ├── spot_order_form.dart         (trading order form)
│   └── spot_market_chart.dart       (market chart widget)
└── usecases/
    (placeholder for future business logic)
```

## Features

### Market Display
- List of available spot markets (BTC/USD, ETH/USD, SOL/USD, DOGE/USD, XRP/USD)
- Real-time market data display including:
  - Current price
  - 24h change percentage (with color indication)
  - 24h high and low prices
  - 24h trading volume

### Trading Interface
- Interactive market selection
- Buy/Sell order form with:
  - Quantity input
  - Price input
  - Buy button (green)
  - Sell button (red)

### Market Chart
- Large chart display area for selected market
- TODO: Integrate TradingView or Lightweight Charts library

## Routing

The spot markets page is accessible at `/spot-markets` via the app router:

```dart
GoRoute(
  name: 'spot-markets',
  path: '/spot-markets',
  builder: (BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (BuildContext context) => SpotMarketsBloc(),
      child: const DesktopSpotMarketsPage(),
    );
  },
)
```

## State Management

### SpotMarketsBloc Events
- `SpotMarketsInitialize`: Load available markets and data
- `SpotMarketsRefresh`: Refresh all market data
- `SpotMarketSelected`: Change selected market
- `SpotMarketBuyOrderPlaced`: Execute buy order
- `SpotMarketSellOrderPlaced`: Execute sell order

### SpotMarketsBloc States
- `SpotMarketsInitial`: Initial state
- `SpotMarketsLoading`: Loading markets
- `SpotMarketsLoaded`: Markets loaded successfully
- `SpotMarketsError`: Error occurred
- `SpotMarketOrderPlaced`: Order successfully placed

## TODO Items

1. **Chart Integration**: Integrate TradingView Lightweight Charts or similar library for real-time charting
2. **Blockchain Integration**: Connect to actual blockchain/DEX for:
   - Real market data fetching
   - Order placement execution
   - Transaction handling
3. **Order History**: Display user's trading history and open orders
4. **Advanced Trading Features**:
   - Limit orders
   - Stop loss orders
   - Take profit orders
5. **Portfolio Tracking**: Show user's holdings in each market
6. **Mobile Responsive**: Add mobile view for spot markets
7. **WebSocket Integration**: Real-time price updates via WebSocket

## Models

### SpotMarketModel
```dart
SpotMarketModel(
  symbol: String,
  currentPrice: double,
  change24h: double,
  high24h: double,
  low24h: double,
  volume24h: double,
)
```

### SpotOrderModel
```dart
SpotOrderModel(
  orderId: String,
  symbol: String,
  side: String, // 'BUY' or 'SELL'
  quantity: double,
  price: double,
  timestamp: DateTime,
)
```

## Navigation

To navigate to the spot markets page from anywhere in the app:

```dart
context.go('/spot-markets');
// or
context.goNamed('spot-markets');
```

## Future Enhancements

- Multi-chain support (currently mock data)
- User authentication for order execution
- Advanced charting with technical indicators
- Price alerts and notifications
- Wallet integration for balance management
