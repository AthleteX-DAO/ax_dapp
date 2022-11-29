import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AthletePageLongGraph extends StatelessWidget {
  const AthletePageLongGraph({
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
      tooltipBehavior: _longToolTipBehavior,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      zoomPanBehavior: _zoomPanBehavior,
      series: [
        FastLineSeries<GraphData, DateTime>(
          name: 'Book Value',
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
              color: Colors.orange,
            ),
          ),
          enableTooltip: true,
          color: Colors.white,
          width: 2,
          opacity: 1,
          dashArray: <double>[5, 5],
        )
      ],
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Md(),
      ),
      primaryYAxis: NumericAxis(
        rangePadding: ChartRangePadding.round,
        majorGridLines: const MajorGridLines(
          width: 0,
        ),
        interval: 100,
        labelFormat: '{value}AX',
        numberFormat: NumberFormat.decimalPattern(),
      ),
    );
  }
}
