import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class ShowDetailsWidget extends StatefulWidget {
  ShowDetailsWidget({
    super.key,
    required this.promptDetails,
  });

  final String promptDetails;

  @override
  State<ShowDetailsWidget> createState() => _ShowDetailsWidget();
}

class _ShowDetailsWidget extends State<ShowDetailsWidget> {
  final String promptDetails = 'details';
  List<bool> isSelected = [false];
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: (int index) {
        setState(() {
          {
            isSelected[index] = !isSelected[index];
          }
        });
      },
      fillColor: primaryOrangeColor,
      children: [
        Text(
          'Show Details >',
          style: textStyle(
            primaryWhiteColor,
            20,
            isBold: false,
            isUline: false,
          ),
        ),
      ],
    );
  }
}
