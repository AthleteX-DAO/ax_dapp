import 'package:flutter/material.dart';

class AthleteXLogo extends StatelessWidget {
  const AthleteXLogo({
    super.key,
    required double height,
  }) : _height = height;

  final double _height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: _height * 0.2,
      child: const Image(
        image: AssetImage('assets/images/AthleteX_Logo_Vector.png'),
      ),
    );
  }
}
