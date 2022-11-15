// ignore_for_file: lines_longer_than_80_chars, avoid_positional_boolean_parameters

import 'package:ax_dapp/scout/view/desktop_scout.dart';
import 'package:ax_dapp/scout/view/mobile_scout.dart';
import 'package:flutter/material.dart';

class Scout extends StatefulWidget {
  const Scout({
    super.key,
  });

  @override
  State<Scout> createState() => _ScoutState();
}

class _ScoutState extends State<Scout> {
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
