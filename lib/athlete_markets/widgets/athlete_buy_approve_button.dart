import 'package:flutter/material.dart';

class AthleteBuyApproveButton extends StatelessWidget {
  const AthleteBuyApproveButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Approve'),
    );
  }
}
