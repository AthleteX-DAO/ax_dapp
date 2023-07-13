import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/prompt_page_details.dart';
import 'package:ax_dapp/prediction/widgets/prompt_page_title.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphSide extends StatelessWidget {
  const GraphSide({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    final hei = _height / 3;
    const indexUnselectedStackBackgroundColor = Colors.transparent;
    final _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      enablePinching: true,
    );
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
          PromptPageDetails(
            wid: wid,
            height: hei,
            promptDetails: predictionModel.details,
          ),
        ],
      ),
    );
  }
}
