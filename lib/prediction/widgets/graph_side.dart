import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/prediction.dart';
import 'package:ax_dapp/prediction/widgets/prompt_page_details.dart';

import 'package:ax_dapp/prediction/widgets/prompt_page_title.dart';
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
                // SizedBox(
                //   width: wid * .875,
                //   height: 150,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           BlocSelector<PredictionPageBloc, PredictionPageState,
                //               AptType>(
                //             selector: (state) => state.aptTypeSelection,
                //             builder: (context, aptTypeSelection) {
                //               return BuyButton(
                //                 athlete: athlete,
                //                 isPortraitMode: _isPortraitMode,
                //                 containerWdt: containerWidth,
                //                 isLongApt: aptTypeSelection.isLong,
                //               );
                //             },
                //           ),
                //           BlocSelector<PredictionPageBloc, PredictionPageState,
                //               AptType>(
                //             selector: (state) => state.aptTypeSelection,
                //             builder: (context, aptTypeSelection) {
                //               return SellButton(
                //                 athlete: athlete,
                //                 isPortraitMode: _isPortraitMode,
                //                 containerWdt: containerWidth,
                //                 isLongApt: aptTypeSelection.isLong,
                //               );
                //             },
                //           ),
                //         ],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           MintButton(
                //             athlete: athlete,
                //             isPortraitMode: _isPortraitMode,
                //             containerWdt: containerWidth,
                //           ),
                //           RedeemButton(
                //             athlete: athlete,
                //             inputLongApt: '',
                //             inputShortApt: '',
                //             valueInAX: '',
                //             isPortraitMode: _isPortraitMode,
                //             containerWdt: containerWidth,
                //           ),
                //         ],
                //       ),
                //       const Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           PredictionPageToolTip(),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
