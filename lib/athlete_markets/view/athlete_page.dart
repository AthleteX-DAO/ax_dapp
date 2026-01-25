import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:flutter/material.dart';

class AthletePage extends StatelessWidget {
  const AthletePage({super.key, required this.athlete});

  final AthleteScoutModel athlete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Athlete')),
      body: Center(
        child: Text('Athlete ${athlete.name.isEmpty ? 'unknown' : athlete.name}'),
      ),
    );
  }
}
