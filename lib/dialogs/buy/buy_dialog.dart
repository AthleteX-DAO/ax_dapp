import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:flutter/material.dart';

/// Placeholder buy dialog while athlete trading is unavailable.
class BuyDialog extends StatelessWidget {
  const BuyDialog({
    required this.athlete,
    required this.athleteName,
    required this.aptPrice,
    required this.athleteId,
    required this.isLongApt,
    super.key,
  });

  final AthleteScoutModel athlete;
  final String athleteName;
  final double aptPrice;
  final int athleteId;
  final bool isLongApt;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trading temporarily unavailable'),
      content: Text(
        'Buying ${isLongApt ? 'long' : 'short'} tokens for $athleteName is currently disabled.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
