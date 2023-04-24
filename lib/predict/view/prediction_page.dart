import 'package:ax_dapp/app/view/app_routing.dart';
import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/prompt_details.dart';
import 'package:ax_dapp/predict/widgets/desktop_prediction_widget.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/graph_side.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PredictionPage extends StatelessWidget {
  PredictionPage({super.key, required this.prediction});

  final PredictionModel prediction;
  final Global global = Global();

  @override
  Widget build(BuildContext context) {
    final paramPrompt = prediction.prompt;

    if (global.pageName != 'prediction') {
      context.goNamed(
        global.pageName,
        params: {'id': paramPrompt},
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TopNavigationBarWeb(page: global.pageName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: const BottomNavigationBarWeb(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurredBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SizedBox(
          height: 660,
          width: MediaQuery.of(context).size.width / 2,
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GraphSide(
                    predictionModel: prediction,
                  ),
                  PromptDetails(
                    model: prediction,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
