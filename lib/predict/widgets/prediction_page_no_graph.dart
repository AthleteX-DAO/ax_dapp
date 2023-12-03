import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Container();
  }
}
