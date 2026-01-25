import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/prediction.dart';
import 'package:ax_dapp/prediction/widgets/prediction_page_combined_graph.dart';
import 'package:ax_dapp/prediction/widgets/prediction_page_tooltip.dart';
// import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
// import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphSide extends StatelessWidget {
  const GraphSide({
    super.key,
    required this.predictionModel,
    required this.chartStats,
    required this.containerHeight,
    required this.containerWidth,
  });

  final PredictionModel predictionModel;
  final List<GraphData> chartStats;
  final double containerHeight;
  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    final _height = MediaQuery.sizeOf(context).height;
    var wid = _width * 0.4;
    if (_width < 1160) wid = containerWidth;
    final _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
    final _tooltipBehavior = TooltipBehavior(enable: true);
    return Container(
      height: _height / 1.5,
      width: wid,
      constraints: const BoxConstraints(
        minHeight: 650,
        maxHeight: 850,
      ),
      child: Column(
        children: [
          PromptPageTitle(
            wid: wid,
            prompt: predictionModel.prompt,
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: wid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: wid * .875,
                  height: _height * .5,
                  padding: const EdgeInsets.all(12),
                  decoration: GoldTheme.panel(radius: 14),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28,
                          right: 28,
                          top: 14,
                        ),
                        child: (chartStats.isEmpty)
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.show_chart,
                                      color: Colors.white38,
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Price history will appear here',
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : PredictionPageCombinedGraph(
                                chartStats: chartStats,
                                tooltipBehavior: _tooltipBehavior,
                                zoomPanBehavior: _zoomPanBehavior,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: wid * .875,
                  height: 26,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PredictionPageToolTip(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
