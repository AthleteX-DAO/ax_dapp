import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

SfCartesianChart buildLongChart(
  List<GraphData> chartStats,
  TooltipBehavior _longToolTipBehavior,
  ZoomPanBehavior _zoomPanBehavior,
) {
  return SfCartesianChart(
    tooltipBehavior: _longToolTipBehavior,
    legend: Legend(isVisible: true),
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
