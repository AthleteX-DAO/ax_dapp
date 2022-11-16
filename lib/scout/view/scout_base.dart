import 'package:ax_dapp/scout/view/desktop_scout.dart';
import 'package:ax_dapp/scout/view/mobile_scout.dart';
import 'package:flutter/material.dart';

class Scout extends StatelessWidget {
  const Scout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 715) {
          return const DesktopScout();
        } else {
          return const MobileScout();
        }
      },
    );
  }
}
