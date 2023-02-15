import 'package:ax_dapp/service/global.dart';
import 'package:flutter/material.dart';

class DesktopLeague extends StatelessWidget {
  const DesktopLeague({super.key});

  @override
  Widget build(BuildContext context) {
    final global = Global();
    return global.buildPage(
      context,
      const Center(
        child: Text('This is the League Page'),
      ),
    );
  }
}
