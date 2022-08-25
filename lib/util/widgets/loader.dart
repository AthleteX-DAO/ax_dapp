import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.dimension = 50});

  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: dimension,
        width: dimension,
        child: const CircularProgressIndicator(
          color: Colors.amber,
        ),
      ),
    );
  }
}
