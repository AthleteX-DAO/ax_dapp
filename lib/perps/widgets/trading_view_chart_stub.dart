import 'package:flutter/material.dart';

/// Stub widget for non-web platforms.
class TradingViewChart extends StatelessWidget {
  const TradingViewChart({
    super.key,
    this.symbol = 'BINANCE:BTCUSDT',
    this.interval = '60',
    this.theme,
    this.height,
  });

  final String symbol;
  final String interval;
  final String? theme;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final effectiveHeight = height ?? (width < 700 ? 320 : 480);

    return Container(
      height: effectiveHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Chart is available on Web'),
    );
  }
}
