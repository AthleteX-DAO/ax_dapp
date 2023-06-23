import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/widgets/desktop_headers.dart';
import 'package:ax_dapp/prediction/widgets/desktop_prediction.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context
        .read<TopNavigationBarBloc>()
        .add(const SelectButtonEvent(buttonName: 'predict'));
    context
        .read<BottomNavigationBarBloc>()
        .add(const SelectItemEvent(itemIndex: 0));
    return BlocBuilder<PredictPageBloc, PredictPageState>(
      builder: (context, state) {
        final bloc = context.read<PredictPageBloc>();
        global.predictions = state.predictions;
        final currentPredictions = state.predictions;
        if (state.status == BlocStatus.loading ||
            state.status == BlocStatus.initial) {
          bloc.add(const LoadPredictionsEvent());
        }
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight * 0.90,
              width: constraints.maxWidth * 0.99,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  DesktopHeaders(
                    minTeamWidth: minTeamWidth,
                    minViewWidth: minViewWidth,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      SizedBox(
                        height: constraints.maxHeight * 0.8 - 120,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: currentPredictions.length,
                          itemBuilder: (context, index) {
                            return DesktopPrediction(
                              predictionModel: currentPredictions[index],
                              minTeamWidth: minTeamWidth,
                              minViewWidth: minViewWidth,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
