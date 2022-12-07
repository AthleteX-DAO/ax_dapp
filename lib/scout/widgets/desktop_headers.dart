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
    final _width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 66,
        ),
        const SizedBox(
          width: 140,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Athlete (Seasonal APT)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
        if (_width >= minTeamWidth)
          SizedBox(
            // width: 125,
            width: _width * 0.12 > 125 ? _width * 0.12 : 125,
            child: Text(
              'Team',
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
          width: _width * 0.18 > 175 ? _width * 0.18 : 175,
          child: Text(
            'Market Price / Change',
            style: textStyle(
              Colors.grey[400]!,
              10,
              isBold: false,
              isUline: false,
            ),
          ),
        ),
        SizedBox(
          // width: 175,
          width: _width * 0.18 > 175 ? _width * 0.18 : 175,
          child: Text(
            'Book Value / Change',
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
