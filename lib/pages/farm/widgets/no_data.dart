import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 70,
        width: 320,
        child: Text(
          'No Farms to Display.',
          style: TextStyle(color: Colors.amber, fontSize: 30),
        ),
      ),
    );
  }
}
