import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionPageNoGraph extends StatelessWidget {
  const PredictionPageNoGraph({
    super.key,
    required this.chartStats,
    required TooltipBehavior shortToolTipBehavior,
    required ZoomPanBehavior zoomPanBehavior,
  })  : _shortToolTipBehavior = shortToolTipBehavior,
        _zoomPanBehavior = zoomPanBehavior;

  final List<GraphData> chartStats;
  final TooltipBehavior _shortToolTipBehavior;
  final ZoomPanBehavior _zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: _shortToolTipBehavior,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      zoomPanBehavior: _zoomPanBehavior,
      series: [
        FastLineSeries<GraphData, DateTime>(
          name: 'No Token',
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
              color: Colors.white,
            ),
          ),
          enableTooltip: true,
          color: Colors.orange,
          width: 2,
          opacity: 1,
          dashArray: <double>[5, 5],
        ),
      ],
    );
  }
}
