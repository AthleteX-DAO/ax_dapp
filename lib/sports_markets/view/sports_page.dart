import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:flutter/material.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({super.key, required this.sport});

  final SportsMarketsModel sport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sports Market')),
      body: Center(child: Text(sport.name.isEmpty ? 'No sport' : sport.name)),
    );
  }
}
