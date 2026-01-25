import 'package:flutter/material.dart';

class AthleteMintApproveButton extends StatelessWidget {
  const AthleteMintApproveButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Approve Mint'),
    );
  }
}
