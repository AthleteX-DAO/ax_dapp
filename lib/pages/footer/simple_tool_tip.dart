import 'package:flutter/material.dart';

class SimpleToolTip extends StatelessWidget {
  final String message;
  final Widget widget;
  const SimpleToolTip(this.message, this.widget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 0),
      height: 20,
      padding: EdgeInsets.all(20),
      preferBelow: true,
      decoration: BoxDecoration(
          color: Colors.grey[800], borderRadius: BorderRadius.circular(50)),
      richMessage: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: this.message,
              style: TextStyle(color: Colors.grey[400], fontSize: 16)),
        ],
      ),
      child: this.widget,
    );
  }
}
