import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/desktop_headers.dart';
import 'package:ax_dapp/predict/widgets/desktop_prediction.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:get/get.dart';

class DesktopPredict extends StatefulWidget {
  const DesktopPredict({
    super.key,
  });

  @override
  State<DesktopPredict> createState() => _DesktopPredictState();
}

class _DesktopPredictState extends State<DesktopPredict> {
  Global global = Global();
  double minTeamWidth = 875;
  double minViewWidth = 1090;

  @override
  Widget build(BuildContext context) {
    return global.buildPage(context,
        BlocBuilder<PredictPageBloc, PredictPageState>(
            builder: (context, state) {
      final bloc = context.read<PredictPageBloc>();
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: constraints.maxHeight * 0.90,
          width: constraints.maxWidth * 0.99,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Dividing line for the rest of the app
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Divider(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                height: 40,
                child: Row(
                  children: [
                    Text(
                      'Athlete Predictions',
                      style: textStyle(
                        Colors.white,
                        18,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),
              // List Headers
              DesktopHeaders(
                minTeamWidth: minTeamWidth,
                minViewWidth: minViewWidth,
              ),
              // Body
              Stack(
                alignment: Alignment.center,
                children: [
                  if (state.status == BlocStatus.loading) const Loader(),
                  DesktopPrediction(
                    predictionModel: const PredictionModel(
                      prompt:
                          'Will Gervonta ‘Tank’ Davis beat Ryan ‘King’ Garcia on April 22nd?',
                      details:
                          'This market will resolve to “Yes” if Gervonta Davis wins his fight on April 22, 2023. Otherwise, this market will resolve to “No”. A “No” resolution would mean Ryan Garcia won the flight. The resolution source for this market will be WBA or a consensus of credible reporting will also suffice. If the fight is canceled, postponed, or ends in a draw, Yes and No will resolve to 50/50.',
                    ),
                    minTeamWidth: minTeamWidth,
                    minViewWidth: minViewWidth,
                  )
                ],
              ),
            ],
          ),
        );
      });
    }));
  }
}
