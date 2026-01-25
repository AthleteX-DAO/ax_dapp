import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class SpotMarketChart extends StatelessWidget {
  const SpotMarketChart({
    super.key,
    required this.symbol,
    required this.price,
    required this.change24h,
  });

  final String symbol;
  final double price;
  final double change24h;

  @override
  Widget build(BuildContext context) {
    final changeColor = change24h >= 0 ? Colors.green : Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Market header with price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: textStyle(
                    Colors.white,
                    20,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: changeColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    change24h >= 0
                        ? '+${change24h.toStringAsFixed(2)}%'
                        : '${change24h.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: changeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '24h Change',
                  style: textStyle(
                    Colors.white54,
                    11,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Chart placeholder
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    color: Colors.white.withOpacity(0.3),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Chart Placeholder\nIntegrate TradingView or Lightweight Charts',
                    textAlign: TextAlign.center,
                    style: textStyle(
                      Colors.white.withOpacity(0.4),
                      13,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
