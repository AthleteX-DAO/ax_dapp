import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// Combined Yes/No graph - single chart instead of two overlapping ones
class PredictionPageCombinedGraph extends StatelessWidget {
  const PredictionPageCombinedGraph({
    super.key,
    required this.chartStats,
    required this.tooltipBehavior,
    required this.zoomPanBehavior,
  });

  final List<GraphData> chartStats;
  final TooltipBehavior tooltipBehavior;
  final ZoomPanBehavior zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SfCartesianChart(
        primaryXAxis: const DateTimeAxis(),
        primaryYAxis: const NumericAxis(
          minimum: 0,
          maximum: 1,
          interval: 0.2,
        ),
        tooltipBehavior: tooltipBehavior,
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          itemPadding: 12,
          overflowMode: LegendItemOverflowMode.wrap,
        ),
        zoomPanBehavior: zoomPanBehavior,
        series: <CartesianSeries<GraphData, DateTime>>[
          // Yes Token line
          FastLineSeries<GraphData, DateTime>(
            name: 'Yes Token',
            dataSource: chartStats,
            xValueMapper: (GraphData data, _) => data.date,
            yValueMapper: (GraphData data, _) => data.price,
            dataLabelSettings: const DataLabelSettings(
              textStyle: TextStyle(
                fontSize: 10,
                color: Color(0xFFFFD700),
              ),
            ),
            enableTooltip: true,
            color: const Color(0xFFFFD700),
            width: 2,
            opacity: 1,
            dashArray: const <double>[5, 5],
          ),
          // No Token line
          FastLineSeries<GraphData, DateTime>(
            name: 'No Token',
            dataSource: chartStats,
            xValueMapper: (GraphData data, _) => data.date,
            yValueMapper: (GraphData data, _) => data.price,
            enableTooltip: true,
            color: Colors.white,
            width: 2,
            opacity: 1,
            dashArray: const <double>[5, 5],
          ),
        ],
      ),
    );
  }
}
