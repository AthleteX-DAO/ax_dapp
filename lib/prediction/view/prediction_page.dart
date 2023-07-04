import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/widgets/graph_side.dart';
import 'package:ax_dapp/prediction/widgets/prompt_details.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    double _containerWdt, _containerHgt;
    return BlocConsumer<PredictionPageBloc, PredictionPageState>(
      listener: (context, state) {
        final bloc = context.read<PredictionPageBloc>();
        if (state.status == BlocStatus.success) {
          bloc.add(
            PredictionPageLoaded(
              predictionModel: predictionModel,
            ),
          );
        }
      },
      buildWhen: (previous, current) => current.status == BlocStatus.success,
      builder: (context, state) {
        if (_width > 1160 && _height > 660) {
          _containerHgt = _height;
          _containerWdt = _width;
          return SizedBox(
            height: _containerHgt,
            width: _containerWdt,
            child: Center(
              child: SizedBox(
                width: _width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GraphSide(
                      predictionModel: predictionModel,
                    ),
                    PromptDetails(
                      predictionModel: predictionModel,
                    )
                  ],
                ),
              ),
            ),
          );
        }

        _containerHgt = (_height * 0.90) - AppBar().preferredSize.height;
        _containerWdt = _width * 0.95;
        return Container(
          margin: EdgeInsets.only(top: AppBar().preferredSize.height + 10),
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
                      SizedBox(
                        width: _containerWdt,
                        child: GraphSide(
                          predictionModel: predictionModel,
                        ),
                      ),
                      SizedBox(
                        width: _containerWdt,
                        child: PromptDetails(
                          predictionModel: predictionModel,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
