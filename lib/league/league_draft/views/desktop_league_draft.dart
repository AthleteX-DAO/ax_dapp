import 'package:flutter/material.dart';
import 'package:ax_dapp/service/global.dart';

class DesktopLeagueDraft extends StatefulWidget {
  const DesktopLeagueDraft({super.key});

  @override
  State<DesktopLeagueDraft> createState() => _DesktopLeagueDraftState();
}

class _DesktopLeagueDraftState extends State<DesktopLeagueDraft> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: const Text('Is the draft page?'),
    );
  }
}
