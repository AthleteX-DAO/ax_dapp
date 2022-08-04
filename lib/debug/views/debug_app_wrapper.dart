import 'package:ax_dapp/debug/views/debug_helper.dart';
import 'package:flutter/material.dart';

class DebugAppWrapper extends StatelessWidget {
  const DebugAppWrapper({
    required this.home,
    // ignore: unused_element
    super.key,
  });

  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          home,
          const DebugHelper(),
        ],
      ),
    );
  }
}
