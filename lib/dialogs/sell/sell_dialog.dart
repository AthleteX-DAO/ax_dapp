import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:flutter/material.dart';

/// Placeholder sell dialog while athlete trading is unavailable.
class SellDialog extends StatelessWidget {
  const SellDialog({
    required this.athlete,
    required this.aptName,
    required this.aptPrice,
    required this.inputApt,
    required this.aptBalance,
    super.key,
  });

  final AthleteScoutModel athlete;
  final String aptName;
  final double aptPrice;
  final String inputApt;
  final double aptBalance;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trading temporarily unavailable'),
      content: Text('Selling $aptName is currently disabled.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
