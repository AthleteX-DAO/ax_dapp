import 'package:flutter/material.dart';

class Probability extends StatelessWidget {
  const Probability({
    required this.prompt,
  });

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: _width * 0.18 > 175 ? _width * 0.18 : 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [Text('top of column'), Text('bottom of column')],
      ),
    );
  }
}
