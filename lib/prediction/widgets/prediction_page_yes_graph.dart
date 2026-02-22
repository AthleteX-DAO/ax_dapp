import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionPageYesGraph extends StatelessWidget {
  const PredictionPageYesGraph({
    super.key,
    required this.chartStats,
    required TooltipBehavior longToolTipBehavior,
    required ZoomPanBehavior zoomPanBehavior,
  })  : _longToolTipBehavior = longToolTipBehavior,
        _zoomPanBehavior = zoomPanBehavior;

  final List<GraphData> chartStats;
  final TooltipBehavior _longToolTipBehavior;
  final ZoomPanBehavior _zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const DateTimeAxis(),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 1,
        interval: 0.2,
      ),
      tooltipBehavior: _longToolTipBehavior,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        itemPadding: 12,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      zoomPanBehavior: _zoomPanBehavior,
      series: [
        FastLineSeries<GraphData, DateTime>(
          name: 'Yes Token',
          dataSource: chartStats,
          xValueMapper: (
            GraphData data,
            _,
          ) =>
              data.date,
          yValueMapper: (
            GraphData data,
            _,
          ) =>
              data.price,
          dataLabelSettings: const DataLabelSettings(
            textStyle: TextStyle(
              fontSize: 10,
              color: Color(0xFFFFD700),
            ),
          ),
          color: const Color(0xFFFFD700),
          dashArray: const <double>[5, 5],
        ),
        FastLineSeries<GraphData, DateTime>(
          name: 'Market Value',
          dataSource: chartStats,
          xValueMapper: (
            GraphData data,
            _,
          ) =>
              data.date,
          yValueMapper: (
            GraphData data,
            _,
          ) =>
              data.longMarketPrice,
          dataLabelSettings: const DataLabelSettings(
            textStyle: TextStyle(
              fontSize: 10,
              color: Color(0xFFFFD700),
            ),
          ),
          color: Colors.black,
          dashArray: const <double>[5, 5],
        ),
      ],
    );
  }
}
