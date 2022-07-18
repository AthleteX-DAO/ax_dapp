import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black45,
          width: 4,
        ),
      ),
      child: Sparkline(
        //Data must be replaced by individual's portfolio history
        data: const [-2, -1.5, -1, 0, 0.5, 1.0, 2.0, 4.0, 8.0, 25.0],
        averageLine: true,
        lineColor: Colors.green.shade900,
        lineWidth: 3,
        fillColor: Colors.green.shade300,
        fillMode: FillMode.below,
        gridLinelabelPrefix: r'$',
        gridLineLabelPrecision: 2,
        enableGridLines: true,
      ),
    );
  }
}
