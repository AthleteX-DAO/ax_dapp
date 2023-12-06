import 'package:flutter/material.dart';

class CollegeMarkets extends StatelessWidget {
  const CollegeMarkets({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: const Center(
        child: SizedBox(
          height: 70,
          child: Text(
            'Check later for College Markets!',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 30,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}
