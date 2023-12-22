import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/prediction_details_widget.dart';
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
    final _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
    final _longToolTipBehavior = TooltipBehavior(enable: true);
    final _shortToolTipBehavior = TooltipBehavior(enable: true);
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
          SizedBox(
            width: wid,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 28,
                          right: 28,
                          top: 14,
                        ),
                        child: (chartStats.isEmpty)
                            ? const Loader(dimension: 36)
                            : BlocBuilder<PredictionPageBloc,
                                PredictionPageState>(
                                builder: (context, aptTypeSelection) {
                                  return Stack(
                                    children: [
                                      PredictionPageYesGraph(
                                        chartStats: chartStats,
                                        longToolTipBehavior:
                                            _longToolTipBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                      ),
                                      PredictionPageNoGraph(
                                        chartStats: chartStats,
                                        shortToolTipBehavior:
                                            _shortToolTipBehavior,
                                        zoomPanBehavior: _zoomPanBehavior,
                                      ),
                                    ],
                                  );
                                },
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
                        child: PredictionDetailsWidget(predictionModel)
                            .predictionPageDetails(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ProposeButton(),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
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
