import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class DesktopHeaders extends StatelessWidget {
  const DesktopHeaders({
    required this.minTeamWidth,
    required this.minViewWidth,
    super.key,
  });
  final double minTeamWidth;
  final double minViewWidth;

  @override
  Widget build(BuildContext context) {
    // Set the Width of the object
    final _width = MediaQuery.of(context).size.width;

    return Row(
      children: <Widget>[
        const SizedBox(
          width: 66,
        ),
        if (_width >= minTeamWidth)
          SizedBox(
            width: _width * 0.12 > 125 ? _width * 0.12 : 125,
            child: Text(
              'Prediction',
              style: textStyle(
                Colors.grey[400]!,
                12,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
        SizedBox(
          // width: 175,

          // Text: 'Probability' goes here
          width: _width * 0.18 > 175 ? _width * 0.18 : 175,
          child: Text(
            '',
            style: textStyle(
              Colors.grey[400]!,
              10,
              isBold: false,
              isUline: false,
            ),
          ),
        ),
        if (_width >= minViewWidth)
          SizedBox(width: _width * 0.20 + 125)
        else
          SizedBox(width: _width * 0.20)
      ],
    );
  }
}