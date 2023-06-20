import 'package:flutter/material.dart';

class AthleteXLogo extends StatelessWidget {
  const AthleteXLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        minWidth: _width / 3,
        minHeight: _height / 3,
        maxWidth: _width / 2,
        maxHeight: _height / 2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: const Image(
        image: AssetImage('assets/images/AthleteX_Logo_Vector.png'),
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
