import 'dart:async';

import 'package:ax_dapp/api/ax_api_client.dart';
import 'package:ax_dapp/trade_slip/models/trade_slip_data.dart';
import 'package:ax_dapp/trade_slip/widgets/trade_slip_card.dart';
import 'package:flutter/material.dart';

/// A live-updating trade slip that periodically refreshes price and P/L.
///
/// Polls the API every [refreshInterval] (default 60 seconds) to get
/// the current price, then recalculates unrealized P/L.
class LiveTradeTicket extends StatefulWidget {
  const LiveTradeTicket({
    required this.slip,
    required this.apiClient,
    this.refreshInterval = const Duration(seconds: 60),
    super.key,
  });

  /// Initial trade data.
  final TradeSlipData slip;

  /// API client for fetching live prices.
  final AxApiClient apiClient;

  /// How often to poll for price updates.
  final Duration refreshInterval;

  @override
  State<LiveTradeTicket> createState() => _LiveTradeTicketState();
}

class _LiveTradeTicketState extends State<LiveTradeTicket> {
  late TradeSlipData _currentSlip;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _currentSlip = widget.slip;
    _startPolling();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    // Initial fetch
    _fetchLivePrice();

    // Periodic refresh
    _refreshTimer = Timer.periodic(widget.refreshInterval, (_) {
      _fetchLivePrice();
    });
  }

  Future<void> _fetchLivePrice() async {
    try {
      double? livePrice;

      if (_currentSlip.type == SlipType.spot &&
          _currentSlip.marketId != null) {
        // Spot market: fetch current index price
        final priceData =
            await widget.apiClient.fetchSpotPrice(_currentSlip.marketId!);
        if (priceData != null) {
          livePrice = priceData.price;
        }
      }

      // TODO: add prediction market price fetch when API supports it

      if (livePrice != null && mounted) {
        final entryPrice = _currentSlip.price;
        final qty = _currentSlip.quantity ?? _currentSlip.amount / entryPrice;
        final pnl = (livePrice - entryPrice) * qty;
        // Flip sign for SELL/NO positions
        final adjustedPnl =
            (_currentSlip.side == SlipSide.sell ||
                    _currentSlip.side == SlipSide.no)
                ? -pnl
                : pnl;

        setState(() {
          _currentSlip = _currentSlip.copyWith(
            currentPrice: livePrice,
            unrealizedPnl: adjustedPnl,
          );
        });
      }
    } catch (e) {
      debugPrint('LiveTradeTicket price fetch failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: TradeSlipCard(
        key: ValueKey(_currentSlip.currentPrice),
        slip: _currentSlip,
      ),
    );
  }
}
