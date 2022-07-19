import 'package:flutter/material.dart';

class SimpleToolTip extends StatelessWidget {
  const SimpleToolTip(this.message, this.widget, {super.key});
  final String message;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: Duration.zero,
      height: 20,
      padding: const EdgeInsets.all(20),
      preferBelow: true,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(50),
      ),
      richMessage: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: message,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),),
        ],
      ),
      child: widget,
    );
  }
}
