import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpotMarketChart extends StatelessWidget {
  const SpotMarketChart({
    super.key,
    required this.symbol,
    required this.price,
    required this.change24h,
    this.priceHistory = const [],
  });

  final String symbol;
  final double price;
  final double change24h;
  final List<GraphData> priceHistory;

  @override
  Widget build(BuildContext context) {
    final changeColor = change24h >= 0 ? Colors.green : Colors.redAccent;
    // Strip 'sc' prefix if present (scBTC → BTC)
    final cleanSymbol = symbol.startsWith('sc') ? symbol.substring(2) : symbol;
    
    // Generate flat price history if empty
    final chartData = priceHistory.isNotEmpty
        ? priceHistory
      : _generateFallbackPriceHistory(price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Market header with price
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cleanSymbol,
                    style: textStyle(
                      Colors.white,
                      18,
                      isBold: true,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    fontSize: 14,
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Area Chart
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              color: Colors.black.withOpacity(0.8),
              textStyle: const TextStyle(color: Colors.white),
            ),
            series: <CartesianSeries<GraphData, DateTime>>[
              SplineAreaSeries<GraphData, DateTime>(
                dataSource: chartData,
                xValueMapper: (GraphData data, _) => data.date,
                yValueMapper: (GraphData data, _) => data.price,
                color: changeColor.withOpacity(0.3),
                borderColor: changeColor,
                borderWidth: 2,
                gradient: LinearGradient(
                  colors: [
                    changeColor.withOpacity(0.4),
                    changeColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<GraphData> _generateFallbackPriceHistory(double currentPrice) {
    final now = DateTime.now();
    final data = <GraphData>[];

    for (int i = 0; i < 24; i++) {
      final timestamp = now.subtract(Duration(hours: 24 - i));
      data.add(GraphData(timestamp, currentPrice));
    }

    return data;
  }
}
