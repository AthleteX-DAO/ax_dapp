import 'package:ax_dapp/athlete_markets/widgets/buttons.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/prediction.dart';
import 'package:ax_dapp/prediction/widgets/prediction_page_tooltip.dart';

import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tokens_repository/tokens_repository.dart';

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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = _width * 0.4;
    if (_width < 1160) wid = containerWidth;
    const indexUnselectedStackBackgroundColor = Colors.transparent;
    final _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
    final _longToolTipBehavior = TooltipBehavior(enable: true);
    final _shortToolTipBehavior = TooltipBehavior(enable: true);
    final _isPortraitMode =
        MediaQuery.of(context).orientation == Orientation.portrait;
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
          // graph side
          SizedBox(
            width: wid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //build graph
                Container(
                  width: wid * .875,
                  height: _height * .4,
                  decoration: boxDecoration(
                    Colors.transparent,
                    10,
                    1,
                    greyTextColor,
                  ),
                  child: Stack(
                    children: [
                      // Graph
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28,
                          right: 28,
                          top: 14,
                        ),
                        child: (chartStats.isEmpty)
                            ? const Loader(dimension: 36)
                            : BlocSelector<PredictionPageBloc,
                                PredictionPageState, AptType>(
                                selector: (state) => state.aptTypeSelection,
                                builder: (context, aptTypeSelection) {
                                  return IndexedStack(
                                    index: aptTypeSelection.index - 1,
                                    children: [
                                      PredictionPageYesGraph(
                                        chartStats: chartStats,
                                        longToolTipBehavior:
                                            _longToolTipBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      // Price
                    ],
                  ),
                ),
                //give spacing between the graph and the buttons
                const SizedBox(
                  height: 12,
                ),
                //build buttons and tooltip
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
                // Build about tile
                ExpansionTile(
                  title: Text(
                    'About',
                    style: textStyle(
                      Colors.white,
                      20,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  children: [
                    Container(
                      decoration: boxDecoration(
                        Colors.transparent,
                        10,
                        1,
                        greyTextColor,
                      ),
                      width: wid * .875,
                      height: 128,
                      child: Center(
                        child: Text(
                          'Prediction Details go here',
                          textAlign: TextAlign.center,
                          style: textStyle(
                            Colors.white,
                            20,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProposeButton(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
