import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/bloc/predict_page_bloc.dart';
import 'package:ax_dapp/predict/widgets/desktop_headers.dart';
import 'package:ax_dapp/predict/widgets/desktop_prediction_card.dart';
import 'package:ax_dapp/predict/widgets/prediction_loading_status.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/widgets/loader.dart';
import 'package:ethereum_api/tokens_api.dart';
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
  EthereumChain? _selectedChain;
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
        if (_selectedChain != state.selectedChain) {
          _selectedChain = state.selectedChain;
          bloc.add(
            const LoadPredictionsEvent(),
          );
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
                  const DesktopHeaders(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (state.status == BlocStatus.loading) const Loader(),
                      if (state.predictions.isEmpty &&
                          state.status == BlocStatus.success)
                        const PredictionLoadingStatus(
                          message: 'No Active Markets At This Time!',
                        ),
                      if (state.status == BlocStatus.error)
                        const PredictionLoadingStatus(
                          message: 'Failed to Load Markets!',
                        ),
                      SizedBox(
                        height: constraints.maxHeight * 0.8 - 120,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          physics: const BouncingScrollPhysics(),
                          itemCount: currentPredictions.length,
                          itemBuilder: (context, index) {
                            return DesktopPredictionCard(
                              predictionModel: currentPredictions[index],
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
