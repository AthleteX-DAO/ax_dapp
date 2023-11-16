import 'package:ax_dapp/predict/predict.dart';
import 'package:flutter/material.dart';

class Market24HVolume extends StatelessWidget {
  const Market24HVolume({required this.model, super.key});

  final PredictionModel model;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: _width * 0.2,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(r'$2232')],
      ),
    );
  }
}
