import 'package:ax_dapp/app/widgets/top_navigation_bar/top_navigation_bar.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/prediction/prediction.dart';
import 'package:ax_dapp/prediction/widgets/uma_resolver_section.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/material.dart';

class PredictionPageWebView extends StatelessWidget {
  const PredictionPageWebView({
    super.key,
    required this.predictionModel,
    required this.chartStats,
  });

  final PredictionModel predictionModel;
  final List<GraphData> chartStats;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    final _height = MediaQuery.sizeOf(context).height;
    double _containerWdt, _containerHgt;
    // Desktop mode: 2x2 responsive grid
    if (_width > 1160 && _height > 660) {
      _containerHgt = _height;
      _containerWdt = _width;
      return SizedBox(
        height: _containerHgt,
        width: _containerWdt,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: SizedBox(
              width: _width * 0.9,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: graph (top), market intel (bottom)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top-left: Graph
                        Expanded(
                          child: GraphSide(
                            predictionModel: predictionModel,
                            chartStats: chartStats,
                            containerHeight: _containerHgt * 0.5,
                            containerWidth: _containerWdt * 0.45,
                          ),
                        ),
                        const SizedBox(height: 1),
                        // Bottom-left: Market Intel (Rules/UMA/AI)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: UmaResolverSection(
                            marketRules: predictionModel.details,
                            resolverAddress:
                                '0x65070BE91${predictionModel.id.toString().padRight(21, '0')}',
                            createdAt: 'Jan 4, 2026, 1:56 PM EST',
                            resolutionDeadline: 'Jan 31, 2026, 11:59 PM ET',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right column: Market Info
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: _width * 0.35,
                      child: Column(
                        children: [
                          const SizedBox(height: 60),
                          StatsSide(
                            predictionModel: predictionModel,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // stacked scroll (portrait mode)
    final navBarHeight =
        (_width > 1160 && _height > 660) ? kTopNavBarHeightWeb : kTopNavBarHeightMobile;
    final topInset = MediaQuery.paddingOf(context).top + navBarHeight + 10;
    _containerHgt = (_height * 0.90) - navBarHeight;
    _containerWdt = _width * 0.95;
    return Container(
      margin: EdgeInsets.only(top: topInset),
      child: Wrap(
        alignment: WrapAlignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          SizedBox(
            height: _containerHgt,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  // Mobile: Full-width graph
                  SizedBox(
                    width: _containerWdt,
                    child: GraphSide(
                      predictionModel: predictionModel,
                      chartStats: chartStats,
                      containerHeight: _containerHgt,
                      containerWidth: _containerWdt,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mobile: Market info with buy/sell buttons
                  SizedBox(
                    width: _containerWdt,
                    child: StatsSide(
                      predictionModel: predictionModel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mobile: Market Intel (Rules/UMA/AI)
                  SizedBox(
                    width: _containerWdt,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: UmaResolverSection(
                        marketRules: predictionModel.details,
                        resolverAddress:
                            '0x65070BE91${predictionModel.id.toString().padRight(21, '0')}',
                        createdAt: 'Jan 4, 2026, 1:56 PM EST',
                        resolutionDeadline: 'Jan 31, 2026, 11:59 PM ET',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
