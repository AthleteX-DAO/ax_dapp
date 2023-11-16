import 'package:flutter/material.dart';

class MarketProbability extends StatelessWidget {
  const MarketProbability({
    super.key,
    required this.prompt,
  });

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width * 0.18 > 175 ? _width * 0.18 : 175,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [Text('0%')],
      ),
    );
  }
}
