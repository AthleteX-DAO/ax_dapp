/// Trade slip components for prediction and spot market confirmations.
///
/// Usage:
/// ```dart
/// import 'package:ax_dapp/trade_slip/trade_slip.dart';
///
/// // Show confirmation dialog after a trade
/// TradeSlipDialog.show(context, slip: TradeSlipData(...));
///
/// // Embed a live-updating ticket
/// LiveTradeTicket(slip: mySlip, apiClient: axApiClient);
/// ```
library trade_slip;

export 'models/trade_slip_data.dart';
export 'widgets/live_trade_ticket.dart';
export 'widgets/trade_slip_card.dart';
export 'widgets/trade_slip_dialog.dart';
