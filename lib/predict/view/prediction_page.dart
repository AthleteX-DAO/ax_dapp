import 'package:ax_dapp/app/view/app_routing.dart';
import 'package:ax_dapp/app/widgets/widgets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  Global global = Global();
  late PredictionModel predictionModel;

  Color indexUnselectedStackBackgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    if (global.pageName != 'predictions') {
      context.goNamed(global.pageName);
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
        child: const Text('Predictions Page goes here!'),
      ),
    );
  }
}
