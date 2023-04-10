import 'package:ax_dapp/league/models/league.dart';
import 'package:flutter/material.dart';

class DateRange extends StatelessWidget {
  const DateRange({
    super.key,
    required double width,
    required this.league,
    required this.textSize,
  }) : _width = width;

  final double _width;
  final League league;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: _width * 0.2,
        child: Text(
          '${league.dateStart} - ${league.dateEnd}',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: textSize,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
