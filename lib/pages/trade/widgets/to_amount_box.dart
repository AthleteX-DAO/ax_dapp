import 'package:flutter/material.dart';

class ToAmountBox extends StatelessWidget {
  const ToAmountBox({
    super.key,
    required this.amountBoxAndMaxButtonWid,
    required TextEditingController tokenToInputController,
  }) : _tokenToInputController = tokenToInputController;

  final double amountBoxAndMaxButtonWid;
  final TextEditingController _tokenToInputController;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: amountBoxAndMaxButtonWid),
      child: IntrinsicWidth(
        child: TextFormField(
          readOnly: true,
          controller: _tokenToInputController,
          style: TextStyle(color: Colors.grey[400], fontSize: 22),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 22),
            contentPadding: const EdgeInsets.all(9),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
