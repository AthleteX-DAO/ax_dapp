import 'package:ax_dapp/predict/widgets/show_details_widget.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/custom_styles.dart';

class PromptPageDetails extends StatelessWidget {
  const PromptPageDetails({
    super.key,
    required this.wid,
    required this.promptDetails,
    required double width,
    required double height,
  })  : _width = width,
        _height = height;

  final double wid;
  final String promptDetails;
  final double _width;
  final double _height;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: wid,
          height: 100,
          child: Row(
            children: [
              ShowDetailsWidget(
                promptDetails: promptDetails,
              )
            ],
          ),
        );
      },
    );
  }
}
