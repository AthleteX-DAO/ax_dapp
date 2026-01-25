import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:flutter/material.dart';

/// Placeholder mint dialog while athlete minting is unavailable.
class MintDialog extends StatelessWidget {
  const MintDialog({
    required this.athlete,
    required this.aptName,
    required this.inputLongApt,
    required this.inputShortApt,
    required this.valueInAX,
    super.key,
  });

  final AthleteScoutModel athlete;
  final String aptName;
  final String inputLongApt;
  final String inputShortApt;
  final String valueInAX;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Minting temporarily unavailable'),
      content: Text('Minting $aptName is currently disabled.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
