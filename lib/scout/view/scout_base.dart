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
    debugPrint(MediaQuery.of(context).size.width.toString());
    return MediaQuery.of(context).size.width >= 685
        ? const DesktopScout()
        : const MobileScout();
  }
}
