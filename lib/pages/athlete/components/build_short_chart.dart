import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

SfCartesianChart buildShortChart(
  List<GraphData> chartStats,
  TooltipBehavior _shortToolTipBehavior,
  ZoomPanBehavior _zoomPanBehavior,
) {
  return SfCartesianChart(
    tooltipBehavior: _shortToolTipBehavior,
    zoomPanBehavior: _zoomPanBehavior,
    legend: Legend(isVisible: false),
    series: [
      FastLineSeries<GraphData, DateTime>(
        name: 'Price',
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
            15000 - data.price,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
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
      )
    ],
    primaryXAxis: DateTimeAxis(
      dateFormat: DateFormat.Md(),
    ),
    primaryYAxis: NumericAxis(
      majorGridLines: const MajorGridLines(
        width: 0,
      ),
      interval: 100,
      minimum: 4000,
      maximum: 12000,
      labelFormat: '{value}AX',
      numberFormat: NumberFormat.decimalPattern(),
    ),
  );
}
