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

  @override
  Widget build(BuildContext context) {
    return global.buildPage(context,
        BlocBuilder<PredictPageBloc, PredictPageState>(
            builder: (context, state) {
      final bloc = context.read<PredictPageBloc>();
      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          height: constraints.maxHeight * 0.85 + 41,
          width: constraints.maxWidth * 0.99,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// The Desktop Predictions go here!
            ],
          ),
        );
      });
    }));
  }
}
