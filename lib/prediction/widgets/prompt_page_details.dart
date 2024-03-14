import 'package:ax_dapp/prediction/widgets/show_details.dart';
import 'package:flutter/material.dart';

class PromptPageDetails extends StatelessWidget {
  const PromptPageDetails({
    super.key,
    required this.wid,
    required this.height,
    required this.promptDetails,
  });

  final double wid;
  final double height;
  final String promptDetails;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: wid,
          height: height,
          child: Row(
            children: [
              ShowDetails(
                promptDetails: promptDetails,
              ),
            ],
          ),
        );
      },
    );
  }
}
